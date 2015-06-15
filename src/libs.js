var $, $$, genIsThisPage, getElementsByMetadata, getPageMetadata, utils;

$$ = document.querySelectorAll.bind(document);

$ = document.querySelector.bind(document);

utils = {
  prepRegEx: function(str) {
    return str.substr(1, str.length - 2);
  },
  isRegex: function(re) {
    var str;
    str = re.toString();
    return str[0] === '/' && str[str.length - 1] === '/';
  },
  isArray: function(arr) {
    return Object.prototype.toString.call(arr) === '[object Array]';
  },
  bindkey: Mousetrap.bind.bind(Mousetrap)
};

genIsThisPage = function(url) {
  return function(page) {
    var anotherIsThisPage, i, isthis, len, pageSelector, pageurl, pageurlEncoded;
    isthis = false;
    pageSelector = page.domain;
    if (utils.isArray(pageSelector)) {
      anotherIsThisPage = genIsThisPage(url);
      for (i = 0, len = pageSelector.length; i < len; i++) {
        pageurl = pageSelector[i];
        pageurlEncoded = {
          domain: pageurl
        };
        isthis = isthis || anotherIsThisPage(pageurlEncoded);
        if (isthis) {
          break;
        }
      }
    } else if (utils.isRegex(pageSelector)) {
      isthis = url.match(pageSelector);
    } else if (typeof pageSelector === 'string') {
      if (pageSelector === 'default') {
        isthis = $$(page.anchorsel).length !== 0;
      } else {
        isthis = url.indexOf(pageSelector) !== -1;
      }
    }
    if (isthis && (page.exclude != null) && url.match(page.exclude)) {
      isthis = false;
    }
    return isthis;
  };
};

getPageMetadata = function() {
  var i, isThisPage, j, len, len1, maybethis, page, ref, url;
  url = location.href;
  page = null;
  isThisPage = genIsThisPage(url);
  for (i = 0, len = database.length; i < len; i++) {
    maybethis = database[i];
    if (isThisPage(maybethis)) {
      page = maybethis;
      break;
    }
  }
  if (page != null) {
    if (page.pages != null) {
      ref = page.pages;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        page = ref[j];
        if (isThisPage(page)) {
          return page;
        }
      }
    } else {
      return page;
    }
  }
  return null;
};

getElementsByMetadata = function(metadata) {
  var anchorElements, anchorSelector, textElements;
  anchorSelector = metadata.anchorsel;
  anchorElements = $$(anchorSelector);
  if (metadata.hasOwnProperty("textsel")) {
    textElements = $$(metadata.textsel);
  } else {
    textElements = anchorElements;
  }
  return [textElements, anchorElements];
};
