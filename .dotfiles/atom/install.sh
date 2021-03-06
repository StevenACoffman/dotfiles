#!/bin/bash

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
echo "Installing Atom and popular packages"
if [ ! -d "/opt/homebrew-cask/Caskroom/atom" ]; then
  if [ ! -n "$(find /Applications -maxdepth 1 -iname "Atom.app")" ]; then
    brew cask install atom
  fi
fi

apm install Atom-Syntax-highlighting-for-Sass
apm install Zen
apm install ask-stack
apm install atom-beautify
apm install atom-bootstrap3
apm install atom-css-comb
apm install atom-html-preview
apm install autoclose-html
apm install autocomplete-plus
apm install coffee-refactor
apm install color-picker
apm install file-icons
apm install fixmyjs
apm install fonts
apm install git-log
apm install git-plus
apm install git-tab-status
apm install linter
apm install linter-csslint
apm install linter-jscs
apm install linter-jshint
apm install linter-jsxhint
apm install linter-scss-lint
apm install linter-shellcheck
apm install merge-conflicts
apm install project-manager
apm install react
apm install regex-railroad-diagram
apm install script
apm install sort-lines
apm install ssh-config
