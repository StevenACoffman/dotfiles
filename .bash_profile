#!/bin/bash
# This file is just a shim, and the real magic happens in ~/bin/shell/bash_profile
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

#if [ -f ~/bin/bash_functions.sh ]; then
#  source ~/bin/bash_functions.sh
#fi

#if [ -f ~/.bash_aliases ]; then
#  source ~/.bash_aliases
#fi
