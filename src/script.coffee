# Helper Functions
utils =
  format : (char, html) -> "#{char}. " + html
  prepRegEx : (str) -> str.substr(1,str.length - 2)
  isRE  : (re) ->
    str = re.toString()
    str[0] == '/' && str[str.length - 1] == '/'
  isArr : (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
  bindkey : Mousetrap.bind

# vars
symb = '1234567890q'
shmb = '!@#$%^&*()Q'

Pi6 =
  list: []
  page: {}

bind_navigation_keys = (inputsel) ->
  inputsel = inputsel or if Pi6.page.inputsel? then Pi6.page.inputsel else "input[type='text']"
  $i = $(inputsel);
  utils.bindkey 'e', gen_e_key_bind $i, true
  utils.bindkey 'E', gen_e_key_bind $i, false
gen_e_key_bind = ($f, type) ->
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

genLinkOpener = (url, mode) ->
  runtimeOrExtension = if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'

  return (e) ->
    e.preventDefault()
    e.stopPropagation()
    e.stopImmediatePropagation()
    chrome[runtimeOrExtension].sendMessage url:url, mode:mode
    false

gen_is_this_page = (url) ->
  (page) ->
    isthis   = false
    page_selector  = page.domain

    # Check for array first! (utils.isRE converts arrays to string, so it may be passed arrays)
    if      utils.isArr page_selector
      another_is_this_page = gen_is_this_page url
      for pageurl in page_selector
        pageurl_encoded = domain:pageurl # TODO: Clean this hack
        isthis = isthis or another_is_this_page pageurl_encoded
        break if isthis
    else if utils.isRE page_selector
      isthis = url.match page_selector
    else if typeof page_selector is 'string'
      if page_selector is 'default'
        isthis = $(page.anchorsel).length isnt 0
      else
        isthis = url.indexOf(page_selector) isnt -1

    if isthis and page.exclude? and url.match page.exclude # Supports only regex excluding
      isthis = false

    return isthis

get_page = ->
  url = location.href
  page = null

  is_this_page = gen_is_this_page url

  for maybethis in database
    if is_this_page maybethis
      page = maybethis
      break;

  if page?
    if page.pages?
      for page in page.pages
        if is_this_page page
          return page
    else return page
  else null

init = (option) ->

  if typeof option is 'string'
    page = anchorsel:option
  else if typeof option is 'object'
    page = option
  else
    page = do get_page
  return false if not page

  Pi6.page = page
  eles = getEles page
go = ->
  do bind_navigation_keys

  if Pi6.list.length is 0
    throw "Seems as if Pi6 haven't been able to start on this page\n. If $( #{Pi6.page.anchorsel} ).length === 0 and you're seeing stuff on the screen, then it is a bug. Post an issue on https://github.com/wildeyes/Pi6/issues !"

  # do Mousetrap.unbind
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
    this.html utils.format char, this.html()
  else
    tx = this.html()
    this.html tx.substring(4,tx.length)
  this

# TODO: add activate=true and derivative functionality (deactivation)
$.fn.arm = () ->
  this.each () ->
    $this = $ this
    n    = $this.data "Pi6-Index"
    char = symb[n]
    shar = shmb[n]
    url  = this.href
    type = 'keypress
'
    if char in ['0',')'] # Peculiarities
      type = 'keydown'

    this.txt()

    utils.bindkey char, genLinkOpener(url, "inline"), type
    utils.bindkey shar, genLinkOpener(url, "newtab"), type
    utils.bindkey "- #{char}", genLinkOpener url, "inline+newtab"
    utils.bindkey "= #{char}", genLinkOpener url, "inline+newtab"

if init()
  go()
# if Pi6.list.length is 0
#   go()
# else
#   for ele in Pi6.list
#     # debugger
#     for parent in ele.parents()
#       if e.target is parent
#         # The element has been removed - remove it from the list
#         i = Pi6.list.indexOf ele
#         Pi6.list.splice i, 1
