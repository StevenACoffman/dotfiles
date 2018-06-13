#!/bin/sh

for PACKAGE in rbenv ruby-build rbenv-gem-rehash rbenv-default-gems; do
  if [ -z "$(brew ls --versions $PACKAGE)" ]
  then
    brew install $PACKAGE
  fi
done

rbenv install 2.4.0
rbenv global 2.4.0
rbenv shell 2.4.0
# Get Compass and SASS
gem install bundler
gem install rubocop
gem install reek
gem install compass
gem install scss_lint
gem install font-awesome-sass
gem install bootstrap-sass
gem install puppet-lint
exit 0
