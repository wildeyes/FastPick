_default={inline:'f',newtab:'F'};

_keys = {inline:_default.inline,newtab:_default.newtab};

var runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension',
    cou = 0;

KeyboardJS.on('f > 1,2,3,4,5,6,7,8,9',caller);
function open_tab(url, mode) {
    action = {"createProperties":{"url":url},"mode":mode};
    if(mode == "newtab")
        action.createProperties.active = false;
    chrome[runtimeOrExtension].sendMessage(action);
}
function caller(event, keys, combo) {
    console.log(keys);
    mode = "a";

    if (keys[0] == _keys.inline)
        mode = "inline";
    else if (keys[0] == _keys.newtab)
        mode = "newtab";
    if(typeof keys[2] !== 'undefined')
        if(keys[2].match(/[1-9]/)) {
                linknum = parseInt(keys[2],10) - 1;
                url = document.querySelectorAll('h3.r a')[linknum].href
                //open_tab(url,mode);
            }
}