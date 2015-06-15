var runtimeOrExtension;

runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

chrome[runtimeOrExtension].onMessage.addListener(function(message, sender, sendResponse) {
  var mode, ntab;
  ntab = {
    "url": message.url
  };
  mode = message.mode;
  if (mode.indexOf("newtabswitch") !== -1) {
    ntab.active = true;
    return chrome.tabs.create(ntab);
  } else if (mode.indexOf("inline") !== -1) {
    ntab.active = true;
    return chrome.tabs.update(ntab);
  } else if (mode.indexOf("newtab") !== -1) {
    ntab.active = false;
    return chrome.tabs.create(ntab);
  }
});
