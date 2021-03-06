#!/bin/bash

echo "Installing Java stuff"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#Install Java
if [ ! -d "/opt/homebrew-cask/Caskroom/java" ]; then
  brew cask install java
fi

# Install Eclipse
if [ ! -d "/opt/homebrew-cask/Caskroom/eclipse" ]; then
# Control will enter here if $PACKAGE doesn't exist.
#echo $PACKAGE was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "eclipse*")" ]; then
    brew cask install eclipse-jee
  fi
fi

#brew cask install caskroom/homebrew-versions/java6
#brew cask install caskroom/versions/java7

# Install IntelliJ
if [ ! -d "/opt/homebrew-cask/Caskroom/intellij-idea" ]; then
# Control will enter here if $PACKAGE doesn't exist.
#echo $PACKAGE was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "IntelliJ IDEA*")" ]; then
    brew cask install intellij-idea
  fi
fi

## Install Homebrew apps that require java to be installed first
for PACKAGE in tomcat tomcat-native maven; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done

#Install Subversion
if [ -z "$(brew ls --versions subversion)" ]
then
  brew install --with-java subversion
fi
wget http://projectlombok.org/downloads/lombok.jar -O "/Users/$(whoami)/Downloads"
echo "You will need to install lombok"
exit 0
