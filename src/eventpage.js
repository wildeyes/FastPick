var runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

// Bind event:
chrome[runtimeOrExtension].onMessage.addListener(
  function(message, sender, sendResponse) {
    ntab = message.createProperties;
    if(message.mode == "inline")
        chrome.tabs.update(ntab);
    else if (message.mode == "newtab")
        chrome.tabs.create(ntab);
});