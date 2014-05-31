## Fast Pick - shortcuts for search

> How much time you spend searching in Google? Youtube? Wikipedia?
> To search, you type in your query... **and move your hand to the mouse to pick your selection**.
> With Fast Pick, you just click the number associated with the link you want.
> Be a man, man, use keyboard shortcuts that save you time.

Inspired by [Vimium][http://vimium.github.io/], Fast Pick provides keyboard shortcuts for search.
Fast Pick adds numbers to search results so you can press the appropriate number on you keyboard to select the search result you need.

It helps out browsing faster. And it's addicting. Really.

**Installation instructions:**

*Install Fast Pick Now from the* [Chrome Web Store][javascript:(function() { alert(" not uploaded yet! ") })()].

The Help \ Options page can be reached via the button on the address bar \ Omnibar.

Installation from source is just some scrolling away!

## How to Use (Keyboard bindings)

ProTip: Turn off Google Instant. It's not compatible with Pi6... yet.

- Keys 1-9 open the search result in the current tab.
- Shift + 1-9 open the search result in a new tab.
- Plus key + 1-9 open the search result in a new tab and **switches to it**.
- Key e puts cursor focus on the search box \ input.
- Shift+E does a "Select All" focus on the search box.
- Keys j to scroll down, k to scroll up.

## Installation from source

Fast Pick is built with Coffeescript and Grunt.

1. Install [nodejs][http://nodejs.org/]. This also installs NPM.
2. `git clone https://github.com/wildeyes/fastpick && cd fastpick`
3. `npm install -g grunt-cli` - install grunt.
4. `npm install` - install project dependencies (mousetrap, jquery and various grunt tasks).
5. `grunt build`
5. Navigate to `chrome://extensions`.
6. Activate Developer Mode.
7. Click on "Load Unpacked Extension...".
8. Select the `Fast Pick` directory.

Use `grunt` (executes coffeescript watches) for development with Coffeescript.

## Add shortcuts to sites - The Database file

The process of adding shortcuts to sites is a manual one.
You do it by adding a selector that includes all anchor elements of the search results and an optional selector for the element that contains the text of the search result to add the number to, if it's not the same one as the anchor element.
The database is a JS array of "entries", each containing a single site (or group), take a look at it to get an idea of what's possible.

**More information coming soon**.

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
To easily find the selectors I need in a page, I use [SelectorGadget](http://selectorgadget.com/).
