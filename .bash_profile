#!/bin/bash
# This file is just a shim, and the real magic happens in ~/bin/shell/bash_profile
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi


#if [ -f ~/bin/bash_functions.sh ]; then
#  source ~/bin/bash_functions.sh
#fi

#if [ -f ~/.bash_aliases ]; then
#  source ~/.bash_aliases
#fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/gears/.sdkman"
#[[ -s "/Users/gears/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/gears/.sdkman/bin/sdkman-init.sh"
export GOPATH=/Users/scoffman/go

export PATH="$HOME/.cargo/bin:$PATH"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash
