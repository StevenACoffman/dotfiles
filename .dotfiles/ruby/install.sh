#!/bin/sh

for PACKAGE in rbenv ruby-build rbenv-gem-rehash rbenv-default-gems; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done

rbenv install 2.1.3
rbenv global 2.1.3
# Get Compass and SASS
gem install compass
gem install scss-lint
gem install font-awesome-sass
gem install bootstrap-sass
exit 0
