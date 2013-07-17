_default={inline:'f',newtab:'F'};
_keys = {inline:_default.inline,newtab:_default.newtab};
shiftsymbols = '!@#$%^&*()';
links = document.querySelectorAll('h3.r a');

var runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension',
    cou = 0;

function open_tab(url, mode) {
    action = {"createProperties":{"url":url},"mode":mode};
    if(mode == "newtab")
        action.createProperties.active = false;
    chrome[runtimeOrExtension].sendMessage(action);
}
function getUrl(linknum) {
    return links[linknum - 1].href;
} 
function buildLinkOpener(linknum, mode) {
    return function() {
        open_tab(getUrl(linknum),mode);
    }
}

for(var i = 1; i <= 9; i +=1) {

    ele = links[i - 1];
    ele.innerHTML = "["+i+"] " + ele.innerHTML;

    openLink = buildLinkOpener(i,"inline");
    openLinkNewTab = buildLinkOpener(i,"newtab");

    Mousetrap.bind('f ' + i, openLink);
    Mousetrap.bind('F ' + i, openLinkNewTab);
    Mousetrap.bind('F ' + shiftsymbols[i - 1], openLinkNewTab);
}