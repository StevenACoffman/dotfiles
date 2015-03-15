#!/bin/bash

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

for f in /usr/local/etc/bash_completion.d/*; do
   . "$f"
done

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

if [ -f ~/bin/bash_functions.sh ]; then
  source ~/bin/bash_functions.sh
fi

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi


## Add Git Aliases to bash completion/aliases
# ex. git alias "co" would be "gco" on bash, with completion
# More info: https://gist.github.com/mwhite/6887990
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done
