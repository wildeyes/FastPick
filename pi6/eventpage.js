//Initialize Extension
var DEV  = true
   ,branch = DEV ? "dev" : "master"
   ,root   = "https://raw.github.com/wildeyes/Pi6/" + branch
   ,url    = root + "/data/rocket.min.json"
   ,runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

// chrome.runtime.onInstalled.addListener(update)
// chrome.app.runtime.onLaunched.addListener(function() {
//     update()
// }); //-> Doesn't actually work!
function update () {
    $.getJSON(url, function(data) {
        chrome.storage.local.set({"rocket":data});
    })
}

update();

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