## Pi6 Chrome Extension: Better Search

> How much time you spend searching with Google? Youtube? Wikipedia?
> To search, you type in your query... **and move your hand to the mouse to pick your selection**.
> Pi6 eliminates that unnecessary movement.
> Be a man, man, use keyboard shortcuts that save you time.

**Here will be in the near future a screencast featuring... me!**

Pi6 is an Extension for Chrome that makes searching and navigating lists easy. Really. This is not just Apple-speak.

## How?
It just adds numbers to search results, and then you can click the numbers on your keyboard to select the search results.

## Why?

I knew I had to share this extension the moment I tried to use shortcuts for a site I haven't made shortcuts for, a site I never seen before and *got angry that my extension didn't work properly*.

If you want to add\suggest something, **dont'** hesitate to [contact me](364saga@gmail.com).

Promise I don't save any of your precious data.

## How to Use
- Keys 1-9 opens in current tab.
- Shift + 1-9 opens in new tab.
- Ctrl+Shift + 1-9 opens in new tab and **switches to it**.
- Key e focuses on the searchbox.
- Shift+E does a "Select All" focus on the searchbox.
- Keys j to go down, k to go up.

## Adding Pi6-shortcuts to your own sites

### The Database file

Pi6 enables easy adding of new sites by keeping the data and the extension logic decoupled. As a result; adding Pi6 shortcuts to more new sites SUPER easy.
The database is a JS array of objects, "entries", each containing a single site (or group), take a look at it to get the idea of what's possible.

Example Entry:
```coffeescript
entry=
  domain: "google" # the basename of URL
  anchorsel: "h3.r a" # The anchors selector
```

A More complex Entry:
```coffeescript
complex_entry=
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
#### Selectors

To easily find the selectors I need in a page, I use [SelectorGadget](http://selectorgadget.com/).

## Notes
View the [CHANGELOG here](https://github.com/wildeyes/Pi6/master/CHANGELOG.md).
See how to add Pi6 shortcuts to new websites at [ADDING SHORTCUTS](https://github.com/wildeyes/Pi6/master/ADDINGSHORTCUTS.md).