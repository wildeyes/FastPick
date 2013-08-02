function open_tab(url, mode) {
    action = {"createProperties":{"url":url},"mode":mode};
    if(mode == "newtab")
        action.createProperties.active = false;
    chrome[runtimeOrExtension].sendMessage(action);
}
function buildLinkOpener(link, mode) {
    return function() {
        open_tab(link,mode);
    }
}
function buildElementList(type, page) {
    elelist = null;
    
    if ( type == "text" ) 
        if(page.hasOwnProperty("textsel"))
            elelist = $(page.textsel);
        else
            type = "anchor";
    //A nice trick : if textsel is not defined, continue as if type is anchor
    if(type == "anchor") {
        anc = subpage.anchorsel;
        if(typeof anc === "string")
            elelist = $(page.anchorsel);
        else if(typeof anc === "object") {
            elelist = $(anc.iframe).contents().find(anc.anchorsel);
        }
    }
    return elelist;
}
function init_anchors() {
    url = location.href;
    domname = document.domain.split('.')[1]
    for(var i = 0; i < qlist.length; i += 1) {
        page = qlist[i];
        if(domname == page.name) {
            if(page.hasOwnProperty("pages")) {
                subs = page.pages;
                for(var j = 0; j < subs.length; j += 1) {
                    subpage = subs[j];
                    if(url.match(subpage.urlpattern)) {
                        data = {"anchor_ele_list":buildElementList("anchor",subpage)
                          , "text_ele_list": buildElementList("text",subpage)};

                        if( !data.anchor_ele_list || !data.text_ele_list)
                            throw"Error: qList didn't find any links to bind keys to on this page.";

                        return data;
                    }
                }
                return false;
            } else 
                return {
                    "anchor_ele_list":$(page.anchorsel)
                  , "text_ele_list":(page.hasOwnProperty("textsel")) ? $(page.textsel) : $(page.anchorsel),
                    };//document.querySelectorAll(dom.anchorsel);
        }
    }
    throw "Error: Domain " + url + " wasn't found in qList datalist.";
}
function init() {
    var anchor_ele, text_ele, openLink, openLinkNewTab, i = 1;
    do { // We count from 1 for presentation, but store in page/arr from 0.

        try {
            anchor_ele = page.anchor_ele_list[i - 1];
            text_ele = page.text_ele_list[i - 1];
            text_ele.innerHTML = "[" + numbers[i - 1] + "] " + text_ele.innerHTML;
        } catch(e) {
            debugger;
        }
        
        openLink = buildLinkOpener(anchor_ele.href,"inline");
        openLinkNewTab = buildLinkOpener(anchor_ele.href,"newtab");

        if ( i == 1)
            Mousetrap.bind('d', openLink);
        Mousetrap.bind('f ' + numbers[i - 1], openLink);
        Mousetrap.bind('F ' + numbers[i - 1], openLinkNewTab);
        if(i < shiftsymbols.length)
            Mousetrap.bind('F ' + shiftsymbols[i - 1], openLinkNewTab);//workaround for holding shift when pressing numbers
        i += 1
    } while( page.anchor_ele_list.length > ( i - 1 ) && page.text_ele_list.length > ( i - 1 ) && numbers.length > ( i - 1 ) )
}

var //qlist variable from json-data.js
   _default={inline:'f',newtab:'F'}
  , _keys = {inline:_default.inline,newtab:_default.newtab}
  , numbers = '123456789qwertyuiop'
  , shiftsymbols = '!@#$%^&*()' 
  , page = init_anchors()
  , runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';
if(page)
    init();