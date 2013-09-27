url = "https://raw.github.com/wildeyes/Pi6/master/data/rocket.min.json"

do update = ->
    $.getJSON url, (data) ->
        chrome.storage.local.set "rocket":data
