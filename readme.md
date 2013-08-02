qList - Add Awesome Keyboard Shortcuts to Search
===========

qList adds keyboard-shortcuts to **to search engines**.
For example, googling is just searching something and going to another link.
BUT you have to manually *mouse*-click on the links..

AND NO ONE HAS KEYBOARD SHORTCUTS for christ sake.

### Supports (A whole lot more planned):
 - Google Search
 - Youtube Search
 - Cheatography Search
 - Israblog (Israeli blogging system) stuff

How to Use
==========
 - NEW : d opens first option in current tab.
 - f opens in current tab.
 - F opens in new tab.
![Instructions](/screenshot.png "Instructions")

Install Methods
===============
 - As a chrome extension.
 - As a userscript (Not yet updated to v1).

Install - Chrome extension
====
Adding an extension to Chrome Store costs money. So I can't add the extension at the moment. To install:
- [Download Crx from here](https://github.com/wildeyes/qList/raw/master/qlist.crx).
- Go to this address : [chrome://extensions](chrome://extensions), and "drag" the crx file into that page (like it says in [Steps on adding extension from other websites at the bottom of the page](https://support.google.com/chrome_webstore/answer/2664769?p=crx_warning&rd=1)). That should make a install-dialog pop up.

Install - Greasemonkey\Tampermonkey Script
==========================================
- Download userscript.
- Install [the greasemonkey way](http://wiki.greasespot.net/Greasemonkey_Manual:Installing_Scripts) or [the Tampermonkey way](http://tampermonkey.net/faq.php#Q102).

Question \ Complaint \ Encouragement?
=====================================
If you encounter a bug: IF you have a github account, you can open an issue! if not, email me 364saga@gmail.com.

or want to thank me for qList adding much value to your life, or anything else, you should also email me!

TODO
====
- Customizable shortcuts through options page.
- Sublime Text 2 JS-Extension Build System
	- YUI JS Minify Build System (someday)
	- Script building from different files like described in [Fluent 2013](http://www.youtube.com/watch?v=bqfoYaKCYUI)
	- Windows chromix setup?q
- Holding F and pressing numbers opens lots of tabs (I'll have to extend Mousetrap or anyother framework for binding keys on JS)
- Options page.
- J,K keys for up and down.
- U,D for down\up past the last result seen BUT including that last result.
- I'm feeling lucky right froom the Omnibar!
- Support for every keyboard-scheme (e.g clicking the f while typing in russian\korean\arabic) 

Changelist
==========
## v1
 - cheatography shortcuts.
 - israblog shortcuts.
 - enumerations.
 - Shortcut for first option (d);
 - seperated data from system.
 - system now seems more like a framework for adding shortcuts.
 - keyboard shortcuts for multiple lists on one domain
 - keyboard shortcuts for links in iframe
 - Enumeration after 9, until p (1-9, then q until p on the second row of the keyboard)
Thanks
======
qList uses [Mousetrap](http://craig.is/killing/mice) and the template was created using [Extensionizr](http://extensionizr.com).

Also; Mom you're great.