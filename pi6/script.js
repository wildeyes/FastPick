var __ancele = null
   ,rocket = [{
    "dom": "google",
    "anchorsel": "h3.r a"
}, {
    "dom": "nana10",
    "pages": [{
        "dom": /^http:\/\/israblog.nana10.co.il\/$/,
        "textsel": "b",
        "anchorsel": "a.GenenalHompageLinkNoBold"
    }, {
        "dom": /\?blog=\d{3,8}/,
        "anchorsel": "special"
    }]
}, {
    "dom": "youtube",
    "pages": [{
        "dom": /watch\?/,
        "anchorsel": 'li.video-list-item.related-list-item a'
    }, {
        "dom": /results\?/,
        "anchorsel": "li.yt-uix-tile h3 a"
    }]
}, {
    "dom": "thepiratebay",
    "anchorsel": ".detLink"
}, {
    "dom": "quora",
    "anchorsel": ".question_link"
}, {
    "dom": "cheatography",
    "anchorsel": "#body_shadow strong a"
}, {
    "dom": "readthedocs",
    "anchorsel": "#id_search_result a"
}]

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
// $.fn.iFilter = function() { return this.each(function() { return $(this).find('a.list:has(img)').length !== 0 }); };
function buildElementList(type, page) {
    elelist = null;
    if (type == "anchor") {
        elelist = $(page.anchorsel)

        if(page.anchorsel == "special")
            elelist = $('body').find('a.list:has(img[width="32"])').add($('iframe').contents().find('a.list:has(img[width="32"])'));
        __ancele = elelist
    } else if (type == "text")
        if (page.hasOwnProperty("textsel"))
            elelist = $(page.textsel);
        else
            elelist = __ancele;
    return elelist;
}
function get_page() {
    var url = location.href,
        data = null,
        page = null
    for (var i = 0; i < rocket.length; i += 1) {
        page = rocket[i];
        if (url.indexOf(rocket[i].dom) != -1)
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
        data = {'anchor_ele_list':[],'text_ele_list':[]}

    data.anchor_ele_list = buildElementList("anchor", page)
    data.text_ele_list   = buildElementList("text"  , page)

    if(data.anchor_ele_list.length == 0 || data.text_ele_list.length == 0)
        throw "Seems as if Pi6 haven't been able to start on this page\n. $(" + page.anchorsel + ").length === 0 and it shouldn't be. Post an issue on https://github.com/wildeyes/Pi6/issues !"

    return data;
}
function init() {
    var anchor_ele, text_ele, openLink, openLinkNewTab, i = 1;

    Mousetrap.bind('e', buildENav(true));
    Mousetrap.bind('E', buildENav(false));
    Mousetrap.bind('j', function(e) { scrollBy(0, 100); });
    Mousetrap.bind('k', function(e) { scrollBy(0, -100); });
    do { // We count from 1 for pr esentation, but store in page/arr from 0.
        anchor_ele = page.anchor_ele_list[i - 1];
        text_ele = page.text_ele_list[i - 1];
        text_ele.innerHTML = "[" + numbers[i - 1] + "] " + text_ele.innerHTML;
        Mousetrap.bind(numbers[i - 1], buildLinkOpener(anchor_ele.href, "inline"));
        Mousetrap.bind(shiftsymbols[i - 1], buildLinkOpener(anchor_ele.href, "newtab"));
        i += 1
    } while (page.anchor_ele_list.length > (i - 1) && page.text_ele_list.length > (i - 1) && numbers.length > (i - 1))
}
function buildENav(type) {
    $f = $('input:first');
    if(location.href.indexOf('youtube') !== -1)
        $f = $('input#masthead-search-term:first')
    return function(e) {
        e.preventDefault()
        $f.focus()
        if(type) {
            tmpval = $f.val();
            $f.val('');
            $f.val(tmpval);
        } else
            $f.select()
        // This is a very weird solution, but who gives a flying whale.. it works!
    }
}
jQuery(document).ready(function( $ ) {
    numbers = '123456789qw'
    shiftsymbols = '!@#$%^&*(QW'
    page = init_anchors()
    runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';
    if (page)
        init();
});