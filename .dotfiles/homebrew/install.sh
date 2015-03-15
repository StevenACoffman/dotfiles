#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if hash brew 2>/dev/null
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install homebrew packages
#brew install grc coreutils spark

for PACKAGE in git curl lynx mongodb pandoc phantomjs redis shellcheck springboot ssh-copy-id wget; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done
if [ -z "$(brew ls --versions brew-cask)" ]
then
  brew install caskroom/cask/brew-cask
fi

# Install applications
for PACKAGE in atom textmate beyond-compare skype google-chrome firefox sourcetree screenhero keka sublime-text anki tunnelbear vlc stellarium; do
  if [ ! -d "/opt/homebrew-cask/Caskroom/$PACKAGE" ]; then
  # Control will enter here if $PACKAGE doesn't exist.
  APPNAME="$(echo $PACKAGE|tr '-' ' ').app"
  #echo $PACKAGE was not installed with cask
    if [ ! -n "$(find /Applications -maxdepth 1 -iname "$APPNAME")" ]; then
      brew cask install $PACKAGE
    fi
  fi
done

#Iterm2 has legacy app name
if [ ! -d "/opt/homebrew-cask/Caskroom/iterm2" ]; then
#echo iterm2 was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "iterm.app")" ]; then
    brew cask install iterm2
  fi
fi

# Install developer Fonts
brew tap caskroom/fonts
for PACKAGE in font-inconsolata font-source-code-pro font-open-sans font-dejavu-sans; do
  if [ ! -d "/opt/homebrew-cask/Caskroom/$PACKAGE" ]; then
    brew cask install $PACKAGE
  fi
done


exit 0
