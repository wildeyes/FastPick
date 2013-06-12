_default={inline:'x',newtab:'c'};

_keys = {inline:_default.inline,newtab:_default.newtab};

var runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension',
    cou = 0;

KeyboardJS.on('x > 1,2,3,4,5,6,7,8,9',caller);
KeyboardJS.on('c > 1,2,3,4,5,6,7,8,9',caller);
function caller(event, keys, combo) {
    cou += 1;
    mode = "";

    if (keys[0] == _keys.inline)
        mode = "inline";
    else if (keys[0] == _keys.newtab)
        mode = "newtab";
    if(typeof keys[2] !== 'undefined')
        if(keys[2].match(/[1-9]/))
            {
                linknum = parseInt(keys[2],10) - 1;
                action = {createProperties:{url:$('.r a')[linknum].href},mode:mode};
                if(mode == "newtab")
                    action.createProperties.active = false;

                chrome[runtimeOrExtension].sendMessage(action);
            }
}
/*
_keycodes={backspace:'8',tab:'9',enter:'13',shift:'16',ctrl:'17',alt:'18',pause_break:'19',caps_lock:'20',escape:'27',page_up:'33','page down':'34',end:'35',home:'36',left_arrow:'37',up_arrow:'38',right_arrow:'39',down_arrow:'40',insert:'45','delete':'46',0:'48',1:'49',2:'50',3:'51',4:'52',5:'53',6:'54',7:'55',8:'56',9:'57',a:'65',b:'66',c:'67',d:'68',e:'69',f:'70',g:'71',h:'72',i:'73',j:'74',k:'75',l:'76',m:'77',n:'78',o:'79',p:'80',q:'81',r:'82',s:'83',t:'84',u:'85',v:'86',w:'87',x:'88',y:'89',z:'90','left_window key':'91','right_window key':'92',select_key:'93','numpad 0':'96','numpad 1':'97','numpad 2':'98','numpad 3':'99','numpad 4':'100','numpad 5':'101','numpad 6':'102','numpad 7':'103','numpad 8':'104','numpad 9':'105',multiply:'106',add:'107',subtract:'109','decimal point':'110',divide:'111',f1:'112',f2:'113',f3:'114',f4:'115',f5:'116',f6:'117',f7:'118',f8:'119',f9:'120',f10:'121',f11:'122',f12:'123',num_lock:'144',scroll_lock:'145',semi_colon:'186',equal_sign:'187',comma:'188',dash:'189',period:'190',forward_slash:'191',grave_accent:'192',open_bracket:'219',backslash:'220',closebracket:'221',single_quote:'222'};
$('body').keydown('keydown', function(e) {
        var key = e.which, target = null;
        active[key]=true;
        if(key == inlinecode || key == newtabcode)
            e.preventDefault();

        if(active[inlinecode] && isNumcode(key))
            active.inline = true;
        else if(active[newtabcode] && isNumcode(key))
            active.newtab = true;

        if (active.inline) {
            e.preventDefault();
            
        }
    });
function isNumcode(num) {
    tmp = num - 48;
    return (tmp < 10 && tmp > 0);
}*/