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
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/steve/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install homebrew packages
#brew install grc coreutils spark

for PACKAGE in \
git \
duti \
curl \
bash-completion \
lynx \
pandoc \
redis \
shellcheck \
ssh-copy-id \
uncrustify \
asdf \
gh \
jq \
ko \
mage \
fzf \
wget \
watchman; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done


# Install applications
for PACKAGE in \
alfred \
anki \
beyond-compare \
firefox \
google-chrome \
gpg-suite \
imageoptim \
keka \
lastpass \
pop \
skype \
sourcetree \
stellarium \
textmate \
vlc \
; do
  if [ ! -d "/opt/homebrew/Caskroom/$PACKAGE" ]; then
  # Control will enter here if $PACKAGE doesn't exist.
  APPNAME="$(echo $PACKAGE|tr '-' ' ').app"
  #echo $PACKAGE was not installed with cask
    if [ ! -n "$(find /Applications -maxdepth 1 -iname "$APPNAME")" ]; then
      brew install --cask $PACKAGE
    fi
  fi
done

#Iterm2 has legacy item.app name
if [ ! -d "/opt/homebrew/Caskroom/iterm2" ]; then
#echo iterm2 was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "iterm.app")" ]; then
    brew install --cask iterm2
  fi
fi

duti -s sh com.macromates.TextMate
duti -s txt com.macromates.TextMate

# Install developer Fonts
brew tap homebrew/cask-fonts
for PACKAGE in \
font-monoid \
font-fira-code \
font-inconsolata \
font-source-code-pro \
font-open-sans \
font-dejavu-sans \
; do
  if [ ! -d "/opt/homebrew/Caskroom/$PACKAGE" ]; then
    brew install --cask $PACKAGE
  fi
done


exit 0
