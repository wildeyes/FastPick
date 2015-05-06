$$ = document.querySelectorAll.bind(document)
$ = document.querySelector.bind(document)

utils =
  prepRegEx : (str) -> str.substr(1,str.length - 2)
  isRegex  : (re) ->
    str = re.toString()
    str[0] == '/' && str[str.length - 1] == '/'
  isArray : (arr) -> Object.prototype.toString.call( arr ) is '[object Array]'
  bindkey : Mousetrap.bind.bind Mousetrap
genIsThisPage = (url) ->
  (page) ->
    isthis   = false
    pageSelector  = page.domain

    # Check for array first! (utils.isRegex converts arrays to string, so it may be passed arrays)
    if      utils.isArray pageSelector
      anotherIsThisPage = genIsThisPage url
      for pageurl in pageSelector
        pageurlEncoded = domain:pageurl # TODO: Clean this hack
        isthis = isthis or anotherIsThisPage pageurlEncoded
        break if isthis
    else if utils.isRegex pageSelector
      isthis = url.match pageSelector
    else if typeof pageSelector is 'string'
      if pageSelector is 'default'
        isthis = $$(page.anchorsel).length isnt 0
      else
        isthis = url.indexOf(pageSelector) isnt -1

    if isthis and page.exclude? and url.match page.exclude # Supports only regex excluding
      isthis = false

    return isthis

getPageMetadata = ->
  url = location.href
  page = null

  isThisPage = genIsThisPage url

  for maybethis in database
    if isThisPage maybethis
      page = maybethis
      break;

  if page?
    if page.pages?
      for page in page.pages
        if isThisPage page
          return page
    else return page
  null

getElementsByMetadata = (metadata) ->
  anchorSelector = metadata.anchorsel
  anchorElements = $$ anchorSelector

  if metadata.hasOwnProperty "textsel"
    textElements = $$ metadata.textsel
  else
    textElements = anchorElements

  [textElements, anchorElements]