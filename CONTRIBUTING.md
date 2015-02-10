## Installing From Source

FastPick is written in Coffeescript, which compiles to Javascript. To
install FastPick from source:

 1. Install [Coffeescript](http://coffeescript.org/#installation) (`npm i -g coffee-script`).
 1. Run `npm start` from within your FastPick directory. This will install dependencies and compile Coffeescript files to Javascript.
 1. Navigate to `chrome://extensions`.
 1. Toggle into Developer Mode.
 1. Click on "Load Unpacked Extension...".
 1. Select the FastPick directory.

## Development tips

 1. `npm i -g gulp`.
 1. Run `gulp` to watch for changes to coffee files, and have the .js files automatically regenerated