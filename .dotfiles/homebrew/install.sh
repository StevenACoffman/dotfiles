#!/bin/bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# Check for Homebrew
if hash brew 2>/dev/null
then
  echo "  Homebrew is already installed"
else
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install homebrew packages
#brew install grc coreutils spark

for PACKAGE in \
git \
curl \
bash-completion \
lynx \
mas \
pandoc \
redis \
shellcheck \
springboot \
ssh-copy-id \
uncrustify \
wget \
nvm \
watchman; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done
if ! brew info brew-cask &>/dev/null
then
  brew tap homebrew/cask
  brew tap buo/cask-upgrade
fi

# Install applications
for PACKAGE in \
alfred \
anki \
atom \
beyond-compare \
caffeine \
firefox \
google-chrome \
gpg-suite \
imageoptim \
keka \
lastpass \
screenhero \
skype \
sourcetree \
stellarium\
sublime-text \
textmate \
tunnelbear \
vlc \
; do
  if [ ! -d "/opt/homebrew-cask/Caskroom/$PACKAGE" ]; then
  # Control will enter here if $PACKAGE doesn't exist.
  APPNAME="$(echo $PACKAGE|tr '-' ' ').app"
  #echo $PACKAGE was not installed with cask
    if [ ! -n "$(find /Applications -maxdepth 1 -iname "$APPNAME")" ]; then
      brew cask install $PACKAGE
    fi
  fi
done

#Iterm2 has legacy item.app name
if [ ! -d "/opt/homebrew-cask/Caskroom/iterm2" ]; then
#echo iterm2 was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "iterm.app")" ]; then
    brew cask install iterm2
  fi
fi

# Install developer Fonts
brew tap caskroom/fonts
for PACKAGE in \
font-monoid \
font-fira-code \
font-inconsolata \
font-source-code-pro \
font-open-sans \
font-dejavu-sans \
; do
  if [ ! -d "/opt/homebrew-cask/Caskroom/$PACKAGE" ]; then
    brew cask install $PACKAGE
  fi
done


exit 0
