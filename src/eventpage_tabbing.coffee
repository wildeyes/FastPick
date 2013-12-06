runtimeOrExtension = if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'

chrome[runtimeOrExtension].onMessage.addListener (message, sender, sendResponse) ->
    ntab = "url": message.url
    isNewtab = message.mode.indexOf("newtab") isnt -1
    isInline = message.mode.indexOf("inline") isnt -1
    if isNewtab and isInline
        ntab.active = true
        chrome.tabs.create ntab
     else if isInline
        ntab.active = true
        chrome.tabs.update ntab
     else if isNewtab
        ntab.active = false
        chrome.tabs.create ntab