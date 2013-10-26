symb = '01234567890q'
shmb = '0!@#$%^&*()Q'
$anchors = []
$texts = []

$.fn.anchorp = () ->
    n = 0
    this.each ->
        $this = $ this
        n += 1
        char = symb[n]
        shar = shmb[n]
        href = $this.attr "href"
        # if bool is on
        Mousetrap.bind char, buildLinkOpener href, "inline"
        Mousetrap.bind shar, buildLinkOpener href, "newtab"
        Mousetrap.bind "= #{char}", buildLinkOpener href, "inline+newtab"
        # else
        #     Mousetrap.unbind char
        #     Mousetrap.unbind shar
        #     Mousetrap.unbind "+ "+char

$.fn.textp = (bool=on) ->
    n = 0
    this.each ->
        $this = $ this
        n += 1
        char = symb[n]
        shar = shmb[n]

        if bool is on
            $this.html "[#{char}] " + $this.html()
        else
            tx = $this.html()
            $this.html tx.substring(4,tx.length)

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

        if      isRE pagesel
            restr = prepRegEx pagesel
            re = new RegExp restr
            isthis = url.match re
        else if isArr pagesel
            anotherIsThisPage = buildIsThisPage url
            for pageurl in pagesel
                pageurl_encoded = dom:pageurl
                isthis = isthis or anotherIsThisPage pageurl_encoded
                break if isthis
        else if typeof pagesel is 'string'
            if pagesel is 'default'
                isthis = $(page.anchorsel).length isnt 0
            else
                isthis = url.indexOf(pagesel) isnt -1
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
        if type
            tmpval = do $f.val
            $f.val ''
            $f.val tmpval
        else
            do $f.select
        # This is a very weird solution, but who gives a flying whale.. it works!

init = (option) ->
    Mousetrap.bind 'j', -> scrollBy 0,  100
    Mousetrap.bind 'k', -> scrollBy 0, -100

    if typeof option is 'string'
        page = anchorsel:option
    else if typeof option is 'object'
        page = option
    else
        page = do get_page
    # return "No Page" if not page

    eles = getEles page

    bindnav page.input

    if eles.length is 0
        throw "Seems as if Pi6 haven't been able to start on this page\n. If $(${page.anchorsel}).length === 0 and you're seeing stuff on the screen, then it is a bug. Post an issue on https://github.com/wildeyes/Pi6/issues !"

    do Mousetrap.unbind

    $anchors.anchorp()
    $texts.textp()

getEles = (page) ->

    asel = page.anchorsel
    if typeof asel is 'object'
        complexsel = asel
        for own key, val of complexsel
            if key is 'iframe'
                $anchors = $('iframe').contents().find(val)
    else if typeof asel is 'string'
        $anchors = $ asel

    if page.hasOwnProperty "textsel"
            $texts = $ page.textsel
        else
            $texts = $anchors

prepRegEx = (str) -> str.substr(1,str.length - 2)
isRE  = (re) ->re[0] == '/' && re[re.length - 1] == '/'
isArr = (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
_map = Array.prototype.map

window.trysix = (sel) ->
    try
        init(sel)
    catch error
        console.log "Pi6 got $(#{page.anchorsel}).length === 0.\n Check your selectors.\n Master Wildeyes has spoken!"

$(document).ready ->
    init window.page