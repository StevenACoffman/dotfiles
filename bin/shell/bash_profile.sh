#!/bin/bash

# bash_profile

# set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

# Up-front dotfiles configuration
# Not part of `load_dotfiles` because it must be sourced before anything else
# to be sure that commands like `brew` (when installed in a custom location)
# are already added to the PATH.
[ -r $HOME/.dotfilesrc ] && source $HOME/.dotfilesrc;

load_dotfiles() {
    declare -a files=(
        $HOME/bin/shell/bash_options.sh # Options
        $HOME/bin/shell/bash_exports.sh # Exports
        $HOME/bin/shell/bash_aliases.sh # Aliases
        $HOME/bin/shell/functions/* # Functions
        $HOME/bin/shell/bash_prompt.sh # Custom bash prompt
        $HOME/bin/shell/bash_paths.sh # Path modifications
        $HOME/bin/shell/bash_completion.sh # Extra bash completion (e.g. git aliases)
        $HOME/bin/shell/completions/*
        # $(brew --prefix)/etc/bash_completion.d/* # Bash completion (installed via Homebrew)
        $HOME/.bash_profile.local # Local and private settings not under version control (e.g. git credentials)
    )

    # if these files are readable, source them
    for index in ${!files[*]}
    do
        if [[ -r ${files[$index]} ]]; then
            source ${files[$index]}
        fi
    done
}

load_dotfiles
unset load_dotfiles
