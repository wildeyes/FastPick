(function() {
    var __ancele = null
       ,runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension'
       ,rocket=null
       ,domloaded = null
       ,numbers = '1234567890qw'
       ,shiftsymbols = '!@#$%^&*()QW'

    chrome.storage.local.get("rocket",function (data) {
        rocket = data.rocket
        general_init()
    })
    $(document).ready(function() {
        domloaded = true;
        general_init()
    });
    function general_init () {
        if(rocket !== null && domloaded === true) {
            var page = process_page_object()
               ,data = {'anchor_ele_list':[],'text_ele_list':[],"input":''}


            if(page === null)
                return;

            data.anchor_ele_list = buildElementList("anchor", page)
            data.text_ele_list   = buildElementList("text"  , page)
            data.input           = page.input

            bindkeys_navigation(data.input);

            bindkeys_general();

            if(data.anchor_ele_list.length == 0 || data.text_ele_list.length == 0)
                throw "Seems as if Pi6 haven't been able to start on this page\n. $(" + page.anchorsel + ").length === 0 and you're seeing stuff on the screen, then it is a bug. Post an issue on https://github.com/wildeyes/Pi6/issues !"

            pi6process(data);
        }
    }
    function special_init (page_object) {
        if(domloaded === true) {
            var page = process_page_object(page_object)
               ,data = {'anchor_ele_list':[],'text_ele_list':[],"input":page.input}

            data.anchor_ele_list = buildElementList("anchor", page)
            data.text_ele_list   = buildElementList("text"  , page)

            if(data.anchor_ele_list.length == 0 || data.text_ele_list.length == 0)
                throw "Pi6 got $(" + page.anchorsel + ").length === 0.\n Check your selectors. Master wildeyes has spoken!"

            pi6process(data);
        }
    }
    function process_page_object (page) {
        if(typeof page === 'string')
            return {"anchorsel":page}
        else if(typeof page === 'object')
            return page
        else
            return get_page()
    }
    function bindkeys_general () {
        Mousetrap.bind('j', function(e) { scrollBy(0, 100); });
        Mousetrap.bind('k', function(e) { scrollBy(0, -100); });
    }
    function bindkeys_navigation (inputsel) {
        $input = $(inputsel);
        Mousetrap.bind('e', buildENav($input,true));
        Mousetrap.bind('E', buildENav($input,false));
    }
    function pi6process (data) {
        var anchor_ele, text_ele, openLink, openLinkNewTab, i = 1;

        do {
            anchor_ele = data.anchor_ele_list[i - 1];
            text_ele = data.text_ele_list[i - 1];
            text_ele.innerHTML = "[" + numbers[i - 1] + "] " + text_ele.innerHTML;
            Mousetrap.bind(numbers[i - 1]              , buildLinkOpener(anchor_ele.href, "inline"));
            Mousetrap.bind(shiftsymbols[i - 1]         , buildLinkOpener(anchor_ele.href, "newtab"));
            Mousetrap.bind("ctrl+shift+"+ numbers[i - 1], buildLinkOpener(anchor_ele.href, "inline+newtab"));
            i += 1
        } while (data.anchor_ele_list.length > (i - 1) && data.text_ele_list.length > (i - 1) && numbers.length > (i - 1))
    }
    function buildLinkOpener(url, mode) {
        return function() {
            chrome[runtimeOrExtension].sendMessage({"url":url,"mode":mode});
        }
    }
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
    function buildIsThisPage (url) {
        return function (page) {
            pageurl = page.dom
            if(pageurl.indexOf('|') !== -1) {
                pageurls = _.map(pageurl.split('|'),function(dom){ return {"dom":dom}})
                isthis = _.find(pageurls,buildIsThisPage(url))
                return isthis !== undefined
            }
            isthis = url.indexOf(pageurl) !== -1
            return isthis
        }
    }
    function get_page() {
        var url = location.href,
            data = null,
            page = null

        isThisPage = buildIsThisPage(url)
        page = _.find(rocket,isThisPage)
        if(page !== undefined) {
            if(page.pages !== undefined)
                return _.find(pages,isThisPage)
            return page
        }
        return undefined;
    }
    function buildENav($f, type) {
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
    window.pi6process = special_init;
})()