#!/usr/bin/env bash

set -e

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

if [ ! \( -e "./node_modules" \) ]; then
npx yarn
fi

direnv exec . ./rss.coffee &
direnv exec . ./spider/mt.sohu.com.coffee &
direnv exec . ./spider/gelonghui.com.coffee &
direnv exec . ./spider/dwnews.com.coffee &
direnv exec . ./spider/smzdm.com.coffee &

wait

cd data

git add .
git commit -m'U'
git push

