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
brew install git curl lynx mongodb pandoc phantomjs redis shellcheck springboot ssh-copy-id wget
brew install legit
brew install caskroom/cask/brew-cask

# Instal applications
brew cask install java
brew cask install eclipse
brew cask install intellij-idea
brew cask install atom
brew cask install iterm2
brew cask install google-chrome
brew cask install firefox
brew cask install textmate
brew cask install skype
brew cask install screenhero
brew cask install keka
brew cask install sublime-text
brew cask install anki
brew cask install tunnelbear
brew cask install vlc
brew cask install sourcetree
brew cask install stellarium
brew cask install beyond-compare
brew cask install xquartz

exit 0
