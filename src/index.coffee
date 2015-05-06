class FastPick
  numberingFromCSS : false
  runtimeOrExtension : if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'
  identifiers : '1234567890'
  shiftedIdentifiers : '!@#$%^&*()'
  links: []
  actionMain : true

  getActiveList : (identifier) =>
  openUrl : (url, mode) ->
    chrome[@runtimeOrExtension].sendMessage url:url, mode:mode
  openInline : (KBEvent, keyCombo) =>
    @openUrl (@getActiveList @identifiers.indexOf keyCombo), "inline"
  openNewTab : (KBEvent, keyCombo) =>
    @openUrl (@getActiveList @identifiers.indexOf keyCombo), "newtab"
  openNewTabSwitch : (KBEvent, keyCombo) =>
    @openUrl (@getActiveList @identifiers.indexOf keyCombo.substring 2), "newtabswitch"
  toggleAction : => @actionMain ^= true
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
      utils.bindkey "- #{char}", @toggleAction, kbType
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

# Experimental; tried doing the visual numbering via CSS,
# didn't quite workout.
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
