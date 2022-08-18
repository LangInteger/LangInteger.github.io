#!/bin/bash

parentdir=$(dirname $(dirname "$0"))

sed -i .bak 178,304d "$parentdir/public/animation/index.html"

sed -i .bak '178 a\
    <iframe src="./animation.html" frameborder="0" style="overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe>
' "$parentdir/public/animation/index.html"
