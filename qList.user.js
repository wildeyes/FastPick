// ==UserScript==
// @name       qList
// @namespace  https://github.com/wildeyes/qList
// @version    0.0.2
// @description  Add keyboard shortcuts to google-search and youtube!
// @require http://cdn.craig.is/js/mousetrap/mousetrap.min.js
// @include      http*://www.google.*
// @include      http*://www.youtube.com/results?*
// @copyright  2012+, You
// ==/UserScript==

function open_tab(url, mode) {
    if(mode == "newtab")
        GM_openInTab(url);
    else
        window.location = url;
}
function get_url(linknum) {
    return links[linknum - 1].href;
} 
function buildLinkOpener(linknum, mode) {
    return function() {
        open_tab(get_url(linknum),mode);
    }
}
function domainlinks() {
    domain = document.domain.split('.')[1]
    for(var i = 0; i < sources.length; i += 1) {
        dom = sources[i];
        if(dom.name == domain)
            return document.querySelectorAll(dom.source);
    }
    throw "Domain: " + domain + " wasn't found in sources list.";
}
function init() {
    for(var i = 1; i <= 9; i +=1) {
        
        ele = links[i - 1];
        ele.innerHTML = "["+i+"] " + ele.innerHTML;
    
        openLink = buildLinkOpener(i,"inline");
        openLinkNewTab = buildLinkOpener(i,"newtab");
    
        Mousetrap.bind('f ' + i, openLink);
        Mousetrap.bind('F ' + i, openLinkNewTab);
        Mousetrap.bind('F ' + shiftsymbols[i - 1], openLinkNewTab);
    }
}

var sources = [{"name":"google","source":"h3.r a"},{"name":"youtube","source":"li.yt-uix-tile h3 a"}]
  , _default={inline:'f',newtab:'F'}
  , _keys = {inline:_default.inline,newtab:_default.newtab}
  , shiftsymbols = '!@#$%^&*()' //workaround Holding shift when pressing numbers
  , links = domainlinks()

init();