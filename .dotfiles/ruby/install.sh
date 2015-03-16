#!/bin/sh

for PACKAGE in rbenv ruby-build rbenv-gem-rehash rbenv-default-gems; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done

# Get Compass and SASS
gem install compass

exit 0
