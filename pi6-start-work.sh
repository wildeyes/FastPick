#!/usr/bin/env zsh
project_path=`dirname $(realpath $0)`; # To use: sudo apt-get install realpath
google-chrome chrome://extensions &;
subl --project $project_path/pi6.sublime-project &;
node ~/bin/chromix/script/server.js >/dev/null 2>&1 &;
if [ ! -f pi6/test-rocket.min.json ]; then cd pi6; ln data/rocket.min.json pi6/test-rocket.min.json fi
echo "Don't forget to enable is_dev in the manifest.json file~!";