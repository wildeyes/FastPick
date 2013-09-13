#!/usr/bin/env zsh
scripts_path=`dirname $(realpath $0)` # To use: sudo apt-get install realpath
script="$HOME/bin/chromix/script/"
$scripts_path/flyrocket.js &&
node $script/chromix.js with 'chrome://extensions' reload &&
node $script/chromix.js reload