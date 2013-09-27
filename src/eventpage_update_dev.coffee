url = chrome.extension.getURL('test-rocket.min.js')


callback = (data) ->
    chrome.storage.local.set rocket:data
reporter = -> console.log "Failed fetching URL:"+url+"\nProbably an error in the rocket.JSON."

$.ajax
    url: url,
    dataType: 'json',
    success: callback,
    # error: reporter#