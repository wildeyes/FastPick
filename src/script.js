var __ancele = null;

function open_tab(url, mode) {
    action = {
        "createProperties": {
            "url": url
        },
        "mode": mode
    };
    if (mode == "newtab")
        action.createProperties.active = false;
    chrome[runtimeOrExtension].sendMessage(action);
}

function buildLinkOpener(link, mode) {
    return function() {
        open_tab(link, mode);
    }
}

function buildElementList(type, page) {
    elelist = null;
    if (type == "text")
        if (page.hasOwnProperty("textsel"))
            elelist = $(page.textsel);
        else
            elelist = __ancele;
    if (type == "anchor") {
        elelist = $(page.anchorsel)
        
        if(page.anchorsel == "special")
            elelist = $('iframe').contents().find('a.list').filter(function () {return this.href.match(/blogread\.asp\?blog=\d{6}$/); })     
        __ancele = elelist
    }   
    return elelist;
}

function get_page() {
    var url = location.href,
        data = null,
        page = null
    for (var i = 0; i < qlist.length; i += 1) {
        page = qlist[i];
        if (url.indexOf(qlist[i].dom) != -1)
            break;
    }
    data = page.pages;
    if (data == undefined)
        data = page;
    else if (data.length == 1)
        data = page.pages[0];
    else
        for (var i = 0; i < page.pages.length; i += 1) {
            data = page.pages[i]
            if (url.match(data.dom))
                break;
        }
    return data;
}

function init_anchors() {
    var page = get_page(),
        data = {}

    data.anchor_ele_list = buildElementList("anchor", page) //buildElementList('anchor') before text (__ancele)
    data.text_ele_list   = buildElementList("text"  , page)

    return data;
}
//@todo r focuses input not only on gse

function init() {
    var anchor_ele, text_ele, openLink, openLinkNewTab, i = 1;

    Mousetrap.bind('r', function(e) {
        e.preventDefault()
        $('input').focus()
    });
    Mousetrap.bind('j', function(e) {
        scrollBy(0, 100);
    });
    Mousetrap.bind('k', function(e) {
        scrollBy(0, -100);
    });
    //Mousetrap.bind('u', buildLinkOpener('chrome://extensions', 'newtab'));

    do { // We count from 1 for presentation, but store in page/arr from 0.
        anchor_ele = page.anchor_ele_list[i - 1];
        text_ele = page.text_ele_list[i - 1];
        text_ele.innerHTML = "[" + numbers[i - 1] + "] " + text_ele.innerHTML;

        openLink = buildLinkOpener(anchor_ele.href, "inline");
        openLinkNewTab = buildLinkOpener(anchor_ele.href, "newtab");

        if (i == 1)
            Mousetrap.bind('d', openLink);
        Mousetrap.bind('f ' + numbers[i - 1], openLink);
        Mousetrap.bind('F ' + numbers[i - 1], openLinkNewTab);
        if (i < shiftsymbols.length)
            Mousetrap.bind('F ' + shiftsymbols[i - 1], openLinkNewTab); //workaround for holding shift when pressing numbers
        i += 1
    } while (page.anchor_ele_list.length > (i - 1) && page.text_ele_list.length > (i - 1) && numbers.length > (i - 1))
}

var numbers = '123456789qwertyuiop',
    shiftsymbols = '!@#$%^&*()',
    page = init_anchors(),
    runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';
if (page)
    init();