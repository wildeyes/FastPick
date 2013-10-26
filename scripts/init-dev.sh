#!/usr/bin/env zsh
if [[ ! -d "build" ]]
    then
    mkdir build
    ln -s manifest.js build/manifest.js
fi
node $HOME/bin/chromix/script/server.js