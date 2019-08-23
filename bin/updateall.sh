#!/bin/bash

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
#echo 'Update Docker'
#boot2docker upgrade

if hash pip3 2>/dev/null; then
  echo "pip3 install --upgrade pip"
  pip3 install --upgrade pip
fi

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
  #discard old versions:
  #brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
  #brew cask list | xargs brew cask install --force
  # See what has no more dependencies
  #for installed in $(brew list); do
  #  USED_BY=$(brew uses --installed "$installed")
  #  if [[ -z "${USED_BY// }" ]]; then
  #    echo "Nothing depends on $installed"
  #  fi
  #done
  echo "brew update"
  brew update
  echo "brew upgrade"
  brew upgrade
  brew cleanup -s # -s :scrub the cache, removing downloads for even the latest
  brew cask upgrade
  brew cleanup -s
  brew doctor
fi

#TOMCAT_DIR="/usr/local/Cellar/tomcat"
#if [  -d "${TOMCAT_DIR}" ]; then
#  echo updating new tomcat with old config
#  tomcatupdate.sh
#fi
if has apm 2>/dev/null; then
  #update Atom
  apm update --compatible --no-confirm
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
  sudo chown -R "$USER" /usr/local/lib/dtrace/node.d
  sudo chown -R "$USER" /usr/local/share/systemtap/tapset/node.stp
  sudo chown -R "$USER" /usr/local/include/node
  sudo chown -R "$USER" ~/.config
  sudo chown -R "$USER" ~/.npm
  #sudo npm update
  #sudo npm update -g
  ## see https://gist.github.com/othiym23/4ac31155da23962afd0e
  echo "updating node toplevel packages"
  set -e
  set -x

npm-check -gu
  #for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
  #do
#    echo "Installing npm package $package"
#    npm -g install "$package"
#  done
# echo using nvm to set node to latest
#nvm install node --reinstall-packages-from=node
#  @echo "using n to set node to latest"
  #use iojs latest (not node):
  #n io latest

  #use node (not iojs):
  #n io latest
  #n latest
fi
echo "you can hit mas upgrade to upgrade theses apps from the app store:"
mas outdated
echo "install with: mas upgrade"

echo "softwareupdate"
sudo softwareupdate -i -a
