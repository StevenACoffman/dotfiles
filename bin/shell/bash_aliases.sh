#!/bin/bash

# bash_aliases

# Allow aliases to be with sudo
alias sudo="sudo "
alias xcode='open -a /Applications/Xcode.app'
# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias --="cd -"
alias gojs="cd ~/Documents/js"
alias gogit="cd ~/Documents/git"
alias gogo="cd ~/go/src"

# List dir contents aliases
# ref: http://ss64.com/osx/ls.html
# Long form no user group, color
alias l="ls -oG"
# Order by last modified, long form no user group, color
alias lt="ls -toG"
# List all except . and ..., color, mark file types, long form no user group, file size
alias la="ls -AGFoh"
# List all except . and ..., color, mark file types, long form no use group, order by last modified, file size
alias lat="ls -AGFoth"

# Concatenate and print content of files (add line numbers)
alias catn="cat -n"


# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"

# Copy my public key to the pasteboard
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | printf '=> Public key copied to pasteboard.\n'"

# Flush DNS cache
alias flushdns="dscacheutil -flushcache"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

#alias mountmsis="if [ -d /Volumes/MSIS ]; then if [ -d /Volumes/MSIS/MSIS-Argus ]; then echo \"Already mounted\"; else mount -t smbfs #//$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi; else mkdir /Volumes/MSIS; mount -t smbfs //$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi"
#alias mountmgmt="if [ -d /Volumes/mgmt ]; then if [ -d /Volumes/mgmt/deploy ]; then echo \"Already mounted\"; else mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi; else mkdir /Volumes/mgmt; mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi"
#alias mm="date; mountmsis;"
#alias mgmt="date; mountmgmt;"

load_aliases() {
    declare -a files=(
        $HOME/bin/shell/aliases/* # Aliases
    )

    # if these files are readable, source them
    for index in ${!files[*]}
    do
        if [[ -r ${files[$index]} ]]; then
            source ${files[$index]}
        fi
    done
}

load_aliases

#MongoDB
alias startmongo="mongod --config /usr/local/etc/mongod.conf"
