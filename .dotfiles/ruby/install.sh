#!/bin/sh

if hash rbenv 2>/dev/null
then
  echo "  Installing rbenv for you."
  brew install rbenv > /tmp/rbenv-install.log
fi

if hash ruby-build 2>/dev/null
then
  echo "  Installing ruby-build for you."
  brew install ruby-build > /tmp/ruby-build-install.log
fi


gem install compass
