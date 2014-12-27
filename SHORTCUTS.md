## Adding Shortcuts to New Sites ##

The process of adding shortcuts to sites is a manual one.
You do it by adding a selector that includes all anchor elements of the search results and an optional selector for the element that contains the text of the search result to add the number to, if it's not the same one as the anchor element.
The database is a JS array of "entries", each containing a single site (or group), take a look at it to get an idea of what's possible.

To easily find the selectors I need in a page, I use [SelectorGadget](http://selectorgadget.com/).

An Example Entry:
```coffeescript
entry=
    domain: "google" # the basename of URL
        anchorsel: "h3.r a" # The anchors selector
```

A More complex Entry:
```coffeescript
complex_entry =
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
