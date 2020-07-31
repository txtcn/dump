#!/usr/bin/env bash

set -e

#sudo apt-get install -y language-pack-zh-han*

_DIR=$(cd "$(dirname "$0")/.."; pwd)
cd $_DIR

if [ ! -z $GIT_NAME ]; then
git config --global user.email "$GIT_MAIL"
git config --global user.name "$GIT_NAME"
fi

if [ ! -e "data" ]; then
git clone $GIT_DATA --depth=1
fi

install(){
if ! hash $1 2>/dev/null ; then
sudo apt-get install -y $2
fi
}

install node nodejs

if ! hash yarn 2>/dev/null ; then
sudo npm install -g yarn
fi

if ! hash direnv 2>/dev/null ; then
curl -sfL https://direnv.net/install.sh | bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
eval "$(direnv hook bash)"
direnv allow
fi

wait < <(jobs -p)

cp -r README.md data/
