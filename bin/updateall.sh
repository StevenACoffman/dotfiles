#!/bin/bash

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
#echo 'Update Docker'
#boot2docker upgrade

#echo "gvm update"
#gvm selfupdate
if hash gem 2>/dev/null; then
  echo "gem update"
  gem update
fi

if hash rbenv 2>/dev/null; then
  echo "rbenv rehash"
  rbenv rehash
fi

if hash brew 2>/dev/null
then
  USR_LOCAL="/usr/local"
  if [  -d "${USR_LOCAL}" ]; then
  echo "fix up homebrew"
    sudo chown -R "$(whoami)" /usr/local
    cd /usr/local
    #discard unstaged home brew files
    git checkout -- .
    #git reset --hard origin/master
    #git clean -df
  fi

  echo "brew update"
  brew update
  echo "brew upgrade"
  brew upgrade
fi

TOMCAT_DIR="/usr/local/Cellar/tomcat"
if [  -d "${TOMCAT_DIR}" ]; then
  echo updating new tomcat with old config
  tomcatupdate.sh
fi

if hash npm 2>/dev/null; then
  #To clean up node (but remove old tomcats! you can run this:)
  #brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
  echo "fixing up node"
  cd ~
  #npm cache clean
  #sudo npm cache clean
  #sudo curl https://www.npmjs.org/install.sh | sh
  sudo chown -R "$USER" /usr/local/lib/node_modules
  sudo chown -R "$USER" ~/.config
  sudo chown -R "$USER" ~/.npm
  #sudo npm update
  #sudo npm update -g
  ## see https://gist.github.com/othiym23/4ac31155da23962afd0e
  echo "updating node toplevel packages"
  set -e
  set -x

  for package in $(sudo npm -g outdated --parseable --depth=0 | cut -d: -f2)
  do
    echo "Installing npm package $package"
    sudo npm -g install "$package"
  done
  #echo "sudo n latest"
  #sudo n latest
fi
echo "softwareupdate"
sudo softwareupdate -i -a
