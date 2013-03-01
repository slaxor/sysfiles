#!/bin/bash
set -e
SOURCE="$(readlink -f $(dirname "$0"))/sysroot/."
TARGET=${1:-/}

do_install() {
  sudo cp -av $SOURCE $TARGET
  sudo /etc/init.d/nginx restart
  sudo /etc/init.d/dnsmasq restart
  sudo restart mongodb
}

clean() {
  git clean -dfx
}


pull() {
  git pull
  git submodule -q foreach 'echo git config submodule.$path.ignore untracked'
  git submodule update --init
  git submodule foreach git checkout master
}

success_msg() {
  echo 'I have copied all files to their approproate places'
}

pull
do_install
success_msg
