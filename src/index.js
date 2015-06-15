var FastPick, fastpick, metadata,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

FastPick = (function() {
  function FastPick() {
    this.toggleAction = bind(this.toggleAction, this);
    this.openNewTabSwitch = bind(this.openNewTabSwitch, this);
    this.openNewTab = bind(this.openNewTab, this);
    this.openInline = bind(this.openInline, this);
    this.getActiveList = bind(this.getActiveList, this);
  }

  FastPick.prototype.numberingFromCSS = false;

  FastPick.prototype.runtimeOrExtension = chrome.runtime && chrome.runtime.sendMessage ? 'runtime' : 'extension';

  FastPick.prototype.identifiers = '1234567890';

  FastPick.prototype.shiftedIdentifiers = '!@#$%^&*()';

  FastPick.prototype.actionMain = true;

  FastPick.prototype.getActiveList = function(identifier) { return this.anchorEles };

  FastPick.prototype.openUrl = function(url, mode) {
    return chrome[this.runtimeOrExtension].sendMessage({
      url: url,
      mode: mode
    });
  };

  FastPick.prototype.openInline = function(KBEvent, keyCombo) {
    return this.openUrl(this.anchorEles[this.identifiers.indexOf(keyCombo)], "inline");
  };

  FastPick.prototype.openNewTab = function(KBEvent, keyCombo) {
    return this.openUrl(this.anchorEles[this.shiftedIdentifiers.indexOf(keyCombo)], "newtab");
  };

  FastPick.prototype.openNewTabSwitch = function(KBEvent, keyCombo) {
    return this.openUrl(this.anchorEles[this.identifiers.indexOf(keyCombo.substring(2))], "newtabswitch");
  };

  FastPick.prototype.toggleAction = function() {
    return this.actionMain ^= true;
  };

  FastPick.prototype.bindNavigationKeys = function(metadata) {
    var bindNavKey, inputDOMElement, inputsel;
    inputsel = metadata.inputsel != null ? metadata.inputsel : "input[type='text']";
    inputDOMElement = document.querySelector(inputsel);
    bindNavKey = function(inputDOMElement, type) {};
    (function(e) {
      var tmpval;
      e.preventDefault();
      inputDOMElement.focus();
      if (type) {
        tmpval = inputDOMElement.value;
        inputDOMElement.value = '';
        return inputDOMElement.value = tmpval;
      } else {
        return inputDOMElement.select();
      }
    });
    utils.bindkey('e', bindNavKey(inputDOMElement, true));
    return utils.bindkey('E', bindNavKey(inputDOMElement, false));
  };

  FastPick.prototype.setupKeyboardShortcuts = function() {
    var char, i, j, kbType, ref;
    for (i = j = 0, ref = this.identifiers.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      char = this.identifiers[i];
      kbType = char === '0' ? 'keydown' : 'keypress';
      utils.bindkey(char, this.openInline, kbType);
      utils.bindkey(this.shiftedIdentifiers[i], this.openNewTab, kbType);
      utils.bindkey("= " + char, this.openNewTabSwitch, kbType);
      utils.bindkey("- " + char, this.toggleAction, kbType);
    }
    return this;
  };

  FastPick.prototype.start = function() {
    var __anchorEles, _anchorEles, _textEles, e, identifierIndex, ref;
    identifierIndex = 0;
    try {
      this.bindNavigationKeys(metadata);
      ref = getElementsByMetadata(metadata), __anchorEles = ref[0], _textEles = ref[1];
      _anchorEles = Array.prototype.slice.call(__anchorEles);
      this.textEles = Array.prototype.slice.call(_textEles);
      this.anchorEles = _anchorEles.map(function(a) {
        return a.href;
      });
      if (metadata.noNumbering !== true) {
        return this.textEles.forEach((function(_this) {
          return function(ele, index) {
            var char;
            if (!(index < _this.identifiers.length)) {
              return;
            }
            char = _this.identifiers[identifierIndex++];
            return ele.textContent = char + ". " + ele.textContent;
          };
        })(this));
      }
    } catch (_error) {
      e = _error;
      return console.error("FastPick: Hey! I just erred! this is awkward. Could you please report this issue with the following information to https://github.com/wildeyes/fastpick/issues ?", e.stack);
    }
  };

  return FastPick;

})();

metadata = getPageMetadata();

if (metadata !== null) {
  fastpick = new FastPick;
  fastpick.setupKeyboardShortcuts();
  Zepto(document).ready(function() {
    return fastpick.start();
  });
}

