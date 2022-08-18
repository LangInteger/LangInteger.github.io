#!/bin/bash

parentdir=$(dirname $(dirname "$0"))

source ~/.bash_profile &&
nvm install 12.22.12 &&
hexo clean &&
hexo generate &&
bash "$parentdir/shells/build_anim_page.sh" &&
hexo deploy
