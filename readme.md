## Pi6 : Search and lists keyboard shortcuts for the ADHD (Chrome Extension)
Empower yourself with absolutely timesaving keyboard-shortcuts for search and lists with Pi6.

Pi6, or by its other names such as P6 \ Pie 6 \ Pi 6 is an Extension for Chrome \ Chromium (soon for FireFox aswell) that extends your search pages and lists with a unified keyboard shortcut set. That means **no more typing something** into google and then **using the mouse**. It can all be done from the keyboard now.

Searching and navigating lists has never been this easy. Really. This is not just Apple-speak.
I knew I had to share this extension the moment I tried to use shortcuts for a site I haven't made shortcuts for, a site I never seen before and *got angry my extension didn't work*.

Curious to findout what I mean by that? install the extension and search something in google/youtube/many-more.

Also, Pi6 acts as a framework and enables adding new sites and shortcuts REALLY easy. If you want to add\suggest something, **dont'** hesitate to [contact me](364saga@gmail.com).

Promise I don't save any of your precious data.

## How to Use
Keys 1-9 opens in current tab.
Shift + 1-9 opens in new tab.
Key e focuses on the searchbox.
Shift+E does a "Select All" focus on the searchbox.
Keys j to go down, k to go up.

## Install (Very important! Follow carefully or won't work)
- [Download Crx from here](https://github.com/wildeyes/Pi6/raw/master/pi6.crx)
- [Disable Instant](https://www.google.com/search?q=disable+google+instant), which basically sums to click on the preferences on the top right\left (cog icon). (it's crap anyway)
- On windows, you may need to enable "Developers Mode" in the extensions page.
- Drag and drop the crx file to the Extensions page ([Guide to installing chrome extensions manually (not from chrome webstore)](https://www.google.com/search?q=how+to+install+chrome+extensions+manually))
- **Important ProTip**: If an update requires addtional permissions, you will have to re-enable the extension manually. To do that, Click on the "bars" Icon and at the bottom click on "Pi6 Requires new permissions..." and re-enable.

## Thanks
Mom you're great.

## I love making Pi6 using;
- [jQuery](http://jquery.com/) which is so popular and needed, should be loaded automatically in browsers.
- [Chromix](https://github.com/smblott-github/chromix) gives me a CLI interface to Chrome (I refresh chrome tabs, and **the extenstion** directly from my text editor).
- [Mousetrap](http://craig.is/killing/mice) For dead easy keyboard binging.
- [Extensionizr](http://extensionizr.com) created Pi6 extension's template!

## Changelist
v2.21.0:
Add package.json for quick devDependency management via nodejs.
expose a function pi6process ( page_object ) to dev console.
using $.getJSON more reliably (I think).

v2.2.0 : Decouple data and framework. Fetch data from repo, store locally, check periodically for updates.
v2.12.0: Add Ynet
v2.11.1: fix #1 and close #2. Generalized input sys.
v2.1.0:
Error message in console if Pi6 doesn't work properly.
Use .ready().
v2.0.4:
Added q,w as keys.
fix israblog side-iframes bind.
Added Quora.
fix bug search box focus issues.
v2.0.3:
Changed name, facilitated things.
v2:
New shortcuts.
v1.12:
Working CRX file (That stuff is important you know).
Youtube: r focuses on input.
Extra keys.
v1.1:
Keys j,k : scroll down and up.
New site support : ThePirateBay.
New site support : ReadTheDocs.
v1:
New site support : Cheatography.
New site support : Israblog.
New site support : Youtube.
Key d : select first option.
seperated data from system.
Enumeration after 9, until p (1-9, then q until p on the second row of the keyboard)