#!/bin/bash
set -e
SOURCE="$(readlink -f $(dirname "$0"))/sysroot/."
TARGET=${1:-/}

do_install() {
  sudo cp -av $SOURCE $TARGET
  sudo /etc/init.d/nginx restart
  sudo /etc/init.d/dnsmasq restart
  sudo restart mongodb
  rbenv install 1.9.3-p392 --keep
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

add_apt_keys() {
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A040830F7FAC5991 #"Google, Inc. Linux Package Signing Key <linux-packages-keymaster@google.com>"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E0F72778C4676186 #"PlayOnLinux Packaging (PlayOnLinux packaging keys) <packages@playonlinux.com>"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7 #"Valve Corporation <linux@steampowered.com>"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4BD736A82B5C1B00 #"Sylvain Lebresne (pcmanus) <sylvain@datastax.com>"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B5B7720097BB3B58 #"Emdebian Archive Signing Key"

success_msg() {
  echo 'I have copied all files to their approproate places'
}

pull
do_install
add_apt_keys
success_msg
