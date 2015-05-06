$$ = document.querySelectorAll.bind(document)
$ = document.querySelector.bind(document)

utils =
  prepRegEx : (str) -> str.substr(1,str.length - 2)
  isRegex  : (re) ->
    str = re.toString()
    str[0] == '/' && str[str.length - 1] == '/'
  isArray : (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
  bindkey : Mousetrap.bind.bind Mousetrap

class FastPick
  numberingFromCSS : false
  runtimeOrExtension : if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'
  identifiers : '1234567890'
  shiftedIdentifiers : '!@#$%^&*()'
  links: []

  openUrl : (url, mode) ->
    chrome[@runtimeOrExtension].sendMessage url:url, mode:mode
  openInline : (KBEvent, identifier) =>
    @openUrl @anchorEles[@identifiers.indexOf(identifier)], "inline"
  openNewTab : (KBEvent, identifier) =>
    @openUrl @anchorEles[@shiftedIdentifiers.indexOf(identifier)], "newtab"
  openNewTabSwitch : (KBEvent, identifier) =>
    @openUrl @links[@identifiers.indexOf identifier.substring 2], "newtabswitch"
  bindNavigationKeys : (metadata) ->
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
        inputDOMElement.select() # weird solution
    utils.bindkey 'e', bindNavKey inputDOMElement, true
    utils.bindkey 'E', bindNavKey inputDOMElement, false
  setupKeyboardShortcuts : ->
    for i in [0...@identifiers.length]
      char = @identifiers[i]
      kbType = if char is '0' then 'keydown' else 'keypress' # zero char works only with keydown - probably chrome quirks

      utils.bindkey char, @openInline, kbType
      utils.bindkey @shiftedIdentifiers[i], @openNewTab, kbType
      utils.bindkey "= #{char}", @openNewTabSwitch, kbType
      utils.bindkey "- #{char}", @openAction, kbType
    return this
  start : (customAnchorSelector) ->
    identifierIndex = 0
    try
      @bindNavigationKeys metadata
      [__anchorEles, _textEles] = getElementsByMetadata(metadata)

      # Populate array with links that will later be called
      # by the mousetrap keybindings (that were binded early on)
      if customAnchorSelector?
        _anchorEles = Array.prototype.slice.call $$(customAnchorSelector)
      else
        _anchorEles = Array.prototype.slice.call __anchorEles

      @textEles = Array.prototype.slice.call _textEles
      @anchorEles = _anchorEles.map (a) -> a.href

      # Generate numbering to DOM
      if metadata.noNumbering isnt true
        @textEles.forEach (ele, index) =>
          return unless index < @identifiers.length
          char = @identifiers[identifierIndex++]
          ele.textContent = "#{char}. #{ele.textContent}"

    catch e
      console.error "FastPick: Hey! I just erred! this is awkward. Could you please report this issue with the following information to https://github.com/wildeyes/fastpick/issues ?", e.stack

genIsThisPage = (url) ->
  (page) ->
    isthis   = false
    pageSelector  = page.domain

    # Check for array first! (utils.isRegex converts arrays to string, so it may be passed arrays)
    if      utils.isArray pageSelector
      anotherIsThisPage = genIsThisPage url
      for pageurl in pageSelector
        pageurlEncoded = domain:pageurl # TODO: Clean this hack
        isthis = isthis or anotherIsThisPage pageurlEncoded
        break if isthis
    else if utils.isRegex pageSelector
      isthis = url.match pageSelector
    else if typeof pageSelector is 'string'
      if pageSelector is 'default'
        isthis = $$(page.anchorsel).length isnt 0
      else
        isthis = url.indexOf(pageSelector) isnt -1

    if isthis and page.exclude? and url.match page.exclude # Supports only regex excluding
      isthis = false

    return isthis

getPageMetadata = ->
  url = location.href
  page = null

  isThisPage = genIsThisPage url

  for maybethis in database
    if isThisPage maybethis
      page = maybethis
      break;

  if page?
    if page.pages?
      for page in page.pages
        if isThisPage page
          return page
    else return page
  null

getElementsByMetadata = (metadata) ->
  anchorSelector = metadata.anchorsel
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
  Zepto(document).ready () -> fastpick.start()
