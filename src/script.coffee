#utils
Mousetrap = mousetrap || Mousetrap || null
log = console.log
bindkey = Mousetrap.bind
# vars
symb = '1234567890q'
shmb = '!@#$%^&*()Q'
keybuffer = []

Pi6 =
  list: null
  page: null

stop = () -> false
bindnav = (inputsel) ->
  $i = $(inputsel);
  bindkey 'e', buildENav $i, true
  bindkey 'E', buildENav $i, false

buildLinkOpener = (url, mode) ->
  runtimeOrExtension = if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'

  return (e) ->
    e.preventDefault()
    e.stopPropagation()
    e.stopImmediatePropagation()
    chrome[runtimeOrExtension].sendMessage url:url, mode:mode
    false

buildIsThisPage = (url) ->
  (page) ->
    isthis   = false
    pagesel  = page.dom

    if      isRE pagesel
      isthis = url.match pagesel
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
          page
    else page
  else null

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
  bindkey 'j', -> scrollBy 0,  100
  bindkey 'k', -> scrollBy 0, -100


  if typeof option is 'string'
    page = anchorsel:option
  else if typeof option is 'object'
    page = option
  else
    page = do get_page
  # return "No Page" if not page

  Pi6.page = page
  eles = getEles page

  bindnav page.input

  if eles.length is 0
    throw "Seems as if Pi6 haven't been able to start on this page\n. If $( #{page.anchorsel} ).length === 0 and you're seeing stuff on the screen, then it is a bug. Post an issue on https://github.com/wildeyes/Pi6/issues !"

  do Mousetrap.unbind
  do Pi6.list.arm

getEles = (page) ->
  asel = page.anchorsel
  if typeof asel is 'object'
    complexsel = asel
    for own key, val of complexsel
      if key is 'iframe'
        Pi6.list = $('iframe').contents().find(val)
  else if typeof asel is 'string'
    Pi6.list = $ asel

  if page.hasOwnProperty "textsel"
    texts = $ page.textsel
  else
    texts = Pi6.list

  Pi6.list.each (i,e) ->
    $e = $ e
    $e.data "Pi6-Index": i
    e.txt = (activate) ->
      $(texts[i]).enablevisuals(i, activate)
      this

$.fn.enablevisuals = (n, activate=true) ->
  char = symb[n]
  if activate
    this.html "[#{char}] " + this.html()
  else
    tx = this.html()
    this.html tx.substring(4,tx.length)
  this

# TODO: add activate=true and derivative functionality (deactivation)
$.fn.arm = () ->
  this.each () ->
    n    = $(this).data "Pi6-Index"
    char = symb[n]
    shar = shmb[n]
    url  = this.href
    type = 'keypress'

    if char in ['0',')']# Pecularities
      type = 'keydown'

    this.txt()

    bindkey char, buildLinkOpener(url, "inline"), type
    bindkey shar, buildLinkOpener(url, "newtab"), type
    bindkey "- #{char}", buildLinkOpener url, "inline+newtab"
    bindkey "= #{char}", buildLinkOpener url, "inline+newtab"

prepRegEx = (str) -> str.substr(1,str.length - 2)
isRE  = (re) ->
  str = String(re)
  str[0] == '/' && str[str.length - 1] == '/'
isArr = (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
_map = Array.prototype.map

$(document).ready init