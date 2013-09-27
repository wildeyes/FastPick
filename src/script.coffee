rocket             = null
domloaded          = null

class r
    symbols     : '1234567890q',
    shiftsymbols: '!@#$%^&*()Q'
    eles: []

    key: (shift=off) -> if not shift then @symbols[@id - 1] else @shiftsymbols[@id - 1]
    constructor: (anchorelement, textelement) ->
        [@ele, @etx] = [anchorelement, textelement]
        @eles.push(this)
        @id = @eles.length

    text: (led) ->
        if led is on
            char = do @key
            @etx.innerHTML = "[#{char}] " + @etx.innerHTML
        else if led is off
            tx = @etx.innerHTML
            tx = tx.substring(4,tx.length)

    bind: (led) ->
        if led is on
            key = do @key
            Mousetrap.bind key, buildLinkOpener @ele.href, "inline"
            Mousetrap.bind @key(on), buildLinkOpener @ele.href, "newtab"
            Mousetrap.bind "= "+key , buildLinkOpener @ele.href, "inline+newtab"
        else if led is off
            Mousetrap.unbind key
            Mousetrap.unbind @key(on)
            Mousetrap.unbind "+ "+key

    setup: (led=on) ->
        @text led
        @bind led

bindnav = (inputsel) ->
    $i = $(inputsel);
    Mousetrap.bind 'e', buildENav $i, true
    Mousetrap.bind 'E', buildENav $i, false

buildLinkOpener = (url, mode) ->
    runtimeOrExtension = if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'

    return ->
        chrome[runtimeOrExtension].sendMessage url:url, mode:mode

buildIsThisPage = (url) ->
    (page) ->
        isthis   = false
        pagesel  = page.dom
        # pageurls = null
        # re       = null
        # restr    = null

        if isRE pagesel
            restr = prepRegEx pagesel
            re = new RegExp restr
            isthis = url.match re
        else if typeof pagesel is 'string'
            isthis = url.indexOf(pagesel) isnt -1
        else if typeof pagesel is 'array'
            pageurls = _map pagesel, (dom) -> return dom:dom
            anotherIsThisPage = buildIsThisPage url
            isthis = true
            for pageurl in pageurls
                isthis = isthis and anotherIsThisPage pageurl
        # else
            # throw "Given Page.dom: #{page.dom} didn't match any of Pi6 available types for that object (string,/regex_string/)."

        return isthis

get_page = ->
    url = location.href
    page = null

    isThisPage = buildIsThisPage url

    for maybethis in rocket
        if isThisPage maybethis
            page = maybethis
            break;

    if page?
        if page.pages?
            for page in page.pages
                if isThisPage page
                    return page
        return page

    return undefined

buildENav = ($f, type) ->
    (e) ->
        do e.preventDefault
        do $f.focus
        if type?
            tmpval = do $f.val
            $f.val ''
            $f.val tmpval
        else
            do $f.select
        # This is a very weird solution, but who gives a flying whale.. it works!

init = (option) ->
    if rocket isnt null and domloaded is true

        Mousetrap.bind 'j', -> scrollBy 0,  100
        Mousetrap.bind 'k', -> scrollBy 0, -100

        if typeof option is 'string'
            page = anchorsel:option
        else if typeof option is 'object'
            page = option
        # else
            # page = do get_page
        return "No Page" if not page

        eles = getEles page

        bindnav page.input

        if eles.length is 0
            throw "Seems as if Pi6 haven't been able to start on this page\n. $(${page.anchorsel}).length === 0 and you're seeing stuff on the screen, then it is a bug. Post an issue on https://github.com/wildeyes/Pi6/issues !"

        do Mousetrap.unbind

        for ele in eles
            do ele.setup

getEles = (page) ->
    list =
        anchor: []
        text:   []

    asel = page.anchorsel
    if typeof asel is 'object'
        complexsel = asel
        for own key, val of complexsel
            if key is 'iframe'
                list.anchor = $('iframe').contents().find(val)
    else if typeof asel is 'string'
        list.anchor = $ asel

    if page.hasOwnProperty "textsel"
            list.text = $ page.textsel
        else
            list.text = list.anchor

    l = if list.anchor.length < r.prototype.symbols.length then list.anchor.length else r.prototype.symbols.length

    for i in [0..l-1] #maybe.. list.anchor.length :D ?
        new r list.anchor[i], list.text[i]

prepRegEx = (str) -> str.substr(1,str.length - 2)
isRE = (re) ->re[0] == '/' && re[re.length - 1] == '/'
_map = Array.prototype.map

window.trysix = (sel) ->
    try
        init(sel)
    catch error
        console.log "Pi6 got $(#{page.anchorsel}).length === 0.\n Check your selectors.\n Master Wildeyes has spoken!"

do ->
    page = window.page

    chrome.storage.local.get "rocket", (data) ->
        rocket = data.rocket
        window.page = do get_page

    init page

$(document).ready ->
    page = window.page
    domloaded = true;
    init page