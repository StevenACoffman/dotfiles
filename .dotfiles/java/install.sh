#!/bin/bash

echo "Installing Java stuff"


#Install Java
if [ ! -d "/opt/homebrew-cask/Caskroom/java" ]; then
  brew cask install java
fi

# Install Eclipse
if [ ! -d "/opt/homebrew-cask/Caskroom/eclipse" ]; then
# Control will enter here if $PACKAGE doesn't exist.
#echo $PACKAGE was not installed with cask
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "eclipse*")" ]; then
    brew cask install eclipse
  fi
fi

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
