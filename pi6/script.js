(function() {
    var __ancele           = null
       ,is_dev             = chrome.runtime.getManifest().is_dev
       ,runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension'
       ,rocket             = null
       ,domloaded          = null
       ,numbers            = '1234567890qw'
       ,shiftsymbols       = '!@#$%^&*()QW'

    if(is_dev) {
        url = chrome.extension.getURL('test-rocket.min.js')
        reporter = function() { console.log( "Failed fetching URL:"+url+"\nProbably an error in the rocket.JSON." ); };
        $.getJSON(url, function(data) {
            rocket = data;
            general_init()
        }).fail(reporter)
    } else
        chrome.storage.local.get("rocket",function (data) {
            rocket = data.rocket
            general_init()
        })
    $(document).ready(function(event) {
        domloaded = true;
        general_init()
    });
    function general_init (page_object) {
        if(rocket !== null && domloaded === true) {
            var page = process_page_object(page_object)
               ,data = {'anchor_ele_list':[],'text_ele_list':[],"input":''}

            if(page === undefined)
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
               ,data = {'anchor_ele_list':[],'text_ele_list':[],"input":''}

            if(page === null)
                return;

            data.anchor_ele_list = buildElementList("anchor", page)
            data.text_ele_list   = buildElementList("text"  , page)
            data.input           = page.input

            if(data.anchor_ele_list.length == 0 || data.text_ele_list.length == 0)
                throw "Pi6 got $(" + page.anchorsel + ").length === 0.\n Check your selectors. Master wildeyes has spoken!"

            Mousetrap.unbind();

            pi6process(data);
        }
    }
    function show_rocket() {
        chrome.storage.local.get("rocket",function (data) {
            console.log(data);
        })
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
    /*        if(url.match(/israblog\.nana/)) {
            if(url.match(/\?blog=\d{3,8}/))
                data.anchorsel = data.textsel = 'special';
            else
                data = {}
                elelist = $('body').find('a.list:has(img[width="32"])').add($('iframe').contents().find('a.list:has(img[width="32"])'));*/
    function pi6process (data) {
        var anchor_ele, text_ele, openLink, openLinkNewTab, i = 1, binds = [];

        do {
            anchor_ele         = data.anchor_ele_list[i - 1];
            text_ele           = data.text_ele_list[i - 1];

            text_ele.innerHTML = "[" + numbers[i - 1] + "] " + text_ele.innerHTML;

            j      = numbers[i - 1]
            shiftj = shiftsymbols[i - 1]

            binds.push({
                "inline":j
               ,"newtab":shiftj
               ,"inline+newtab":"ctrl+shift+"+ j
            })

            Mousetrap.bind(j                , buildLinkOpener(anchor_ele.href, "inline"));
            Mousetrap.bind(shiftj           , buildLinkOpener(anchor_ele.href, "newtab"));
            Mousetrap.bind("ctrl+shift+"+ j , buildLinkOpener(anchor_ele.href, "inline+newtab"));
            i += 1
        } while (data.anchor_ele_list.length > (i - 1) && data.text_ele_list.length > (i - 1) && numbers.length > (i - 1))

        window.unpi6 = build_unpi6process(data, binds)
    }
    function build_unpi6process (data, bindlist) {
        return function() {
            i = 1
            for(var binds in bindlist) {
                for(var bind in binds)
                    Mousetrap.unbind(binds[bind])
                $t = data.text_ele_list[i - 1].innerHTML;
                $t = $t.substring(4,$t.length);
                i++
            }
        }
    }
    function buildLinkOpener(url, mode) {
        return function() {
            chrome[runtimeOrExtension].sendMessage({"url":url,"mode":mode});
        }
    }
    function buildElementList(type, page) {
        elelist = null;

        if (type == "anchor") {
            asel = page.anchorsel
            if(_.isObject(asel)) {
                complexsel = asel
                for(prop in complexsel)
                    if(complexsel.hasOwnProperty(prop))
                        if(prop.indexOf('iframe') !== -1) {
                            elelist = $('iframe').contents().find(complexsel[prop])
                        }
            } else if(_.isString(asel))
                elelist = $(asel)
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
            var isthis   = false
               ,pagesel  = page.dom
               ,pageurls = null
               ,re       = null
               ,restr = null

            if(isRE(pagesel)) {
                restr = prepareRegex(pagesel)
                re = new RegExp(restr)
                isthis = url.match(re)
            } else if(_.isString(pagesel)) {
                isthis = url.indexOf(pagesel) !== -1

            } else if(_.isArray(pagesel)) {
                pageurls = _.map(pagesel,function(dom){ return {"dom":dom}})
                isthis = _.find(pageurls,buildIsThisPage(url))
                return isthis !== undefined
            } else {
                throw "Given Page.dom:" + page.dom + " didn't match any of Pi6 available types for that object (string,/regex_string/)."
            }
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
                return _.find(page.pages,isThisPage)
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
    function prepareRegex(str) {
        return str.substr(1,str.length - 2);
    }
    window.pi6process = special_init;
    window.show_rocket = show_rocket;
    function isRE (re) {
        return re[0] == '/' && re[re.length - 1] == '/'
    }
})()