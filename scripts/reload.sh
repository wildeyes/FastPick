#!/usr/bin/env zsh
project_path=`dirname $(realpath $0)` # To use: sudo apt-get install realpath
script="$HOME/bin/chromix/script/"
# $project_path/scripts/flyrocket.js
node $script/chromix.js with 'chrome://extensions' reload # node $script/server.js
node $script/chromix.js reload