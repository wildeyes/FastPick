# The Database file

Pi6 enables easy adding of new sites by keeping the data and the extension logic decoupled. As a result; adding Pi6 shortcuts to more new sites SUPER easy.
The database is a JS array of objects, "entries", each containing a single site (or group), take a look at it to get the idea of what's possible.

Example Entry:
```
  domain: "google" # the basename of URL
  anchorsel: "h3.r a" # The anchors selector
```

A More complex Entry:
```
  domain: ["stackoverflow", "serverfault", "superuser", "meta.stackoverflow", "askubuntu", "stackapps", "answers.onstartups", "mathoverflow"] # Match one of those basenames
  pages: [ # In which, there are certain pages
    domain: /search\?q=/ # Match URL to this regex and apply this entry if it's a match
    anchorsel: ".result-link a"
    input: "[name='q']:last"
  , #Otherwise keep going
    domain: "default" # If the last entry (or the first, but you should keep it to the last) domain == "default", it will act as a switch-clause default.
    anchorsel: ".question-hyperlink"
    input: ".textbox[name='q']:last"
  ]
```
## Selectors

To easily find the selectors I need in a page, I use [SelectorGadget](http://selectorgadget.com/).