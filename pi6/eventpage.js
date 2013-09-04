//Initialize Extension
var root = "https://raw.github.com/wildeyes/Pi6/master"
   ,url  =  root + "/data/rocket.min.js"
   ,runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

chrome.runtime.onInstalled.addListener(update)
function update () {
    $.getJSON(url, function(data) {
        chrome.storage.local.set({"rocket":data});
    })
}

chrome[runtimeOrExtension].onMessage.addListener(function(message, sender, sendResponse) {
    // if(arrcmp(['url','mode'],message.hasOwnProperty)) {
        ntab = {"url": message.url}
        if(message.mode == "inline")
            chrome.tabs.update(ntab);
        else if (message.mode == "newtab") {
            ntab.active = false;
            chrome.tabs.create(ntab);
        }
    // }
});
function arrcmp (arr,cmpfun) {
    arr.forEach(function (ele) {if(cmpfun(ele) === false) return false; })
    return true;
}