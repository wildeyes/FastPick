NodeList.prototype.map = Array.prototype.map;
NodeList.prototype.forEach = Array.prototype.forEach;
$$ = document.querySelectorAll.bind(document)
$ = document.querySelector.bind(document)

class FastPick
  numberingFromCSS : false
  runtimeOrExtension : if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'
  identifiers : '1234567890'
  shiftedIdentifiers : '!@#$%^&*()'
  links: []

  openUrl : (url, mode) ->
    chrome[@runtimeOrExtension].sendMessage url:url, mode:mode
  openInline : (KBEvent, identifier) =>
    @openUrl @links[@identifiers.indexOf(identifier)], "inline"
  openNewTab : (KBEvent, identifier) =>
    @openUrl @links[@shiftedIdentifiers.indexOf(identifier)], "newtab"
  openNewTabSwitch : (KBEvent, identifier) =>
    @openUrl @links[@identifiers.indexOf identifier.substring 2], "newtabswitch"
  setupKeyboardShortcuts : ->
    for i in [0...@identifiers.length]
      char = @identifiers[i]
      type = if char is '0' then 'keydown' else 'keypress' # zero char works only with keydown - probably chrome quirks

      utils.bindkey char, @openInline, type
      utils.bindkey @shiftedIdentifiers[i], @openNewTab, type
      utils.bindkey "= #{char}", @openNewTabSwitch, type
      utils.bindkey "- #{char}", @openAction, type
    return this
  start : (customAnchorSelector) ->
    identifierIndex = 0
    try
      bind_navigation_keys metadata
      [anchorEles, textEles] = getElementsByMetadata(metadata)

      # Populate array with links that will later be called
      # by the mousetrap keybindings (that were binded early on)
      @links =
        if customAnchorSelector? then $$(customAnchorSelector).map -> @href
        else anchorEles.map -> @href

      textEles.forEach (ele, index) =>
        return unless index < @identifiers.length
        char = @identifiers[identifierIndex++]
        ele.textContent = "#{char}. #{ele.textContent}"

    catch e
      console.error "FastPick: Hey! I just erred! this is awkward. Could you please report this issue with the following information to https://github.com/wildeyes/fastpick/issues ?", e.stack

# Helper Functions
utils =
  prepRegEx : (str) -> str.substr(1,str.length - 2)
  isRegex  : (re) ->
    str = re.toString()
    str[0] == '/' && str[str.length - 1] == '/'
  isArray : (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
  bindkey : Mousetrap.bind.bind Mousetrap

bind_navigation_keys = (metadata) ->
  inputsel = if metadata.inputsel? then metadata.inputsel else "input[type='text']"
  inputDOMElement = document.querySelector(inputsel);
  bindNavKey = (inputDOMElement, type) ->
  (e) ->
    e.preventDefault()
    inputDOMElement.focus()
    if type
      tmpval = inputDOMElement.value
      inputDOMElement.value = ''
      inputDOMElement.value = tmpval
    else
      inputDOMElement.select()
    # This is a very weird solution, but who gives a flying whale.. it works!
  utils.bindkey 'e', bindNavKey inputDOMElement, true
  utils.bindkey 'E', bindNavKey inputDOMElement, false

gen_is_this_page = (url) ->
  (page) ->
    isthis   = false
    page_selector  = page.domain

    # Check for array first! (utils.isRegex converts arrays to string, so it may be passed arrays)
    if      utils.isArray page_selector
      another_is_this_page = gen_is_this_page url
      for pageurl in page_selector
        pageurl_encoded = domain:pageurl # TODO: Clean this hack
        isthis = isthis or another_is_this_page pageurl_encoded
        break if isthis
    else if utils.isRegex page_selector
      isthis = url.match page_selector
    else if typeof page_selector is 'string'
      if page_selector is 'default'
        isthis = $$(page.anchorsel).length isnt 0
      else
        isthis = url.indexOf(page_selector) isnt -1

    if isthis and page.exclude? and url.match page.exclude # Supports only regex excluding
      isthis = false

    return isthis

getPageMetadata = ->
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
  null

getElementsByMetadata = (metadata) ->
  anchorSelector = metadata.anchorsel
  # There's no db entry containing an iframe yet
  # if typeof anchorSelector is 'object'
  #   complexsel = anchorSelector
  #   for own key, val of complexsel
  #     if key is 'iframe'
  #       anchorElements = $('iframe').contents().find(val)
  # else if typeof anchorSelector is 'string'
  anchorElements = $$ anchorSelector

  if metadata.hasOwnProperty "textsel"
    textElements = $$ metadata.textsel
  else
    textElements = anchorElements

  [textElements, anchorElements]

# if fastpick.numberingFromCSS
#   textsel = if metadata.textsel? then metadata.textsel else metadata.anchorsel
#   ((css) ->
#     # createStyleTag from CSS
#     head = document.head || document.getElementsByTagName("head")[0]
#     style = document.createElement("style")
#     style.type = "text/css"
#     if style.styleSheet
#       style.styleSheet.cssText = css
#     else
#       style.appendChild(document.createTextNode(css))
#     head.appendChild(style))("

# #{textsel}:nth-child(n+9)::before {
#   counter-reset: level1 -1;
#   counter-increment: level1;
#   content: counter(level1) \". \";
# }
# #{textsel}::before {
# content: counter(level1) \". \";
# counter-increment: level1;}

#     ")

metadata = getPageMetadata()

if metadata isnt null
  fastpick = new FastPick

  fastpick.setupKeyboardShortcuts()
  document.onreadystatechange = -> fastpick.start()
