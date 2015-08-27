#!/bin/bash
## Add Git Aliases to bash completion/aliases
# ex. git alias "co" would be "gco" on bash, with completion
# More info: https://gist.github.com/mwhite/6887990
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#test to see if function exists
function_exists() {
  #attempt to declare a local version, which will error if it exists
    declare -f -F $1 > /dev/null
    #find the error code of the last executed command
    return $?
}

for al in $(__git_aliases); do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done
