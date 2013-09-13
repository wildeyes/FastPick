//Initialize Extension
var root   = "https://raw.github.com/wildeyes/Pi6/master"
   ,url    = root + "/data/rocket.min.json"
   ,runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

// chrome.runtime.onInstalled.addListener(update)
// chrome.app.runtime.onLaunched.addListener(function() {
//     update()
// }); //-> Doesn't actually work!
function update () {
    $.getJSON(url, function(data) {
        chrome.storage.local.set({"rocket":data});
    }).fail(function() { console.log( "Failed fetching URL:"+url+"\nProbably an error in the rocket.JSON." ); })
}
update();

chrome[runtimeOrExtension].onMessage.addListener(function(message, sender, sendResponse) {
    ntab = {"url": message.url}
    isNewtab = message.mode.indexOf("newtab") !== -1
    isInline = message.mode.indexOf("inline") !== -1
    if( isNewtab && isInline){
        ntab.active = true;
        chrome.tabs.create(ntab);
    } else if(isInline) {
        ntab.active = true;
        chrome.tabs.update(ntab);
    } else if (isNewtab) {
        ntab.active = false;
        chrome.tabs.create(ntab);
    }
});