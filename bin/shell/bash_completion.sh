#!/bin/bash
#if [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && ! shopt -oq posix; then
#    . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
#fi

#function_exists() {
#    declare -f -F $1 > /dev/null
#    return $?
#}
#git config --get-regexp alias | awk -F'[ .]' '{print $2 }'

#for al in `__git_aliases`; do
#    alias g$al="git $al"
#
#    complete_func=_git_$(__git_aliased_command $al)
#    function_exists $complete_fnc && __git_complete g$al $complete_func
#done
