#!/bin/bash

echo "Installing Java stuff"

brew cask install java
brew cask install eclipse
brew cask install intellij-idea
## Install Homebrew apps that require java to be installed first
brew install tomcat
brew install tomcat-native
brew install --with-java subversion
brew install maven
