runtimeOrExtension = if chrome.runtime and chrome.runtime.sendMessage then 'runtime' else 'extension'

chrome[runtimeOrExtension].onMessage.addListener (message, sender, sendResponse) ->
    ntab = "url": message.url
    mode = message.mode

    if mode.indexOf("newtabswitch") isnt -1
        ntab.active = true
        chrome.tabs.create ntab
    else if mode.indexOf("inline") isnt -1
        ntab.active = true
        chrome.tabs.update ntab
    else if mode.indexOf("newtab") isnt -1
        ntab.active = false
        chrome.tabs.create ntab