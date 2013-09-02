#!/usr/bin/env zsh
script="$HOME/bin/chromix/script/chromix.js"
node $script with 'chrome://extensions/' reload
node $script reload