//Snippet to receive urls and open them as tabs
var runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';
chrome[runtimeOrExtension].onMessage.addListener(
  function(message, sender, sendResponse) {
    ntab = message.createProperties;
    if(message.mode == "inline")
        chrome.tabs.update(ntab);
    else if (message.mode == "newtab")
        chrome.tabs.create(ntab);
});