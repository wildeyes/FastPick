#!/usr/bin/env zsh
# Beware, Dragons (Closure Compiler) Ahead!
# Doesn't work well with JSON : cloc --js assets/rocket.json --js_output_file data/rocket.min.json
project_path=`dirname $(realpath $0)` # To use: sudo apt-get install realpath

google-chrome --load-and-launch-app=$project_path/pi6
pack-pi6