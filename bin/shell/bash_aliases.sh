#!/bin/bash

# bash_aliases

# Allow aliases to be with sudo
alias sudo="sudo "

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

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


#resin
alias startresin="/usr/local/resin/bin/resin_funcs.sh start first; /usr/local/resin/bin/resin_funcs.sh log first"
alias startdebugresin="/usr/local/resin/bin/resin_funcs.sh debug first; /usr/local/resin/bin/resin_funcs.sh log first"
alias resinlog="/usr/local/resin/bin/resin_funcs.sh log first"
alias stopresin="/usr/local/resin/bin/resin_funcs.sh stop first"
#you can stop resin after you have terminated resin
alias sr="startresin; stopresin"
alias str="stopresin"

alias startresinserver="/usr/local/resin/bin/resin_funcs.sh startserver; /usr/local/resin/bin/resin_funcs.sh serverlog"
alias resinserverlog="/usr/local/resin/bin/resin_funcs.sh serverlog"
alias stopresinserver="/usr/local/resin/bin/resin_funcs.sh stopserver"

#jschultz was here
#alias mwar="date; mvn package"
#alias rdp="mvn -DskipTests=true tomcat7:redeploy"
#alias mci="mvn -Denv=${TIER} clean install"
#alias ntb="mvn -Denv=${TIER} -DskipTests=true clean install"


#alias rd1="if [ -d /Volumes/mgmt-1 ]; then cd /Volumes/mgmt-1/deploy/resin_dev_1; else cd /Volumes/mgmt/deploy/resin_dev_1; fi"
#alias rs0="if [ -d /Volumes/mgmt-1 ]; then cd /Volumes/mgmt-1/deploy/resin_staging_0; else cd /Volumes/mgmt/deploy/resin_staging_0; fi"
#alias rp0="cd /Volumes/MSIS/MSIS-Argus/MSIS\ Transfer/WAR\ Transfer/resin_prod0;"

alias resintest="ssh acumen || echo 'Must be running f5.sh vpn to succeed'"
alias resinstaging="ssh martin || echo 'Must be running f5.sh vpn to succeed'"
alias sthuban="ssh thuban || echo 'Must be running f5.sh vpn to succeed'"
alias smenkar="ssh menkar || echo 'Must be running f5.sh vpn to succeed'"
alias sgrus="ssh grus || echo 'Must be running f5.sh vpn to succeed'"

#tomcat
alias stomcat="ssh tomcat1-test"
alias stest="ssh tomcat1-test"
alias sstaging="ssh tomcat1-staging"
alias sprod="ssh tomcat1-prod"


alias tsd="/usr/local/opt/tomcat/libexec/bin/shutdown.sh -force"
alias tsu="/usr/local/opt/tomcat/libexec/bin/startup.sh"
alias tsr="tsd && tsu"
alias debug="tsd || true && /usr/local/opt/tomcat/libexec/bin/catalina.sh jpda start"
alias gojs="cd ~/Documents/js"
alias goweb="cd ~/Documents/git/assessment_services/web/src/main/webapp/WEB-INF"

#MongoDB
alias startmongo="mongod --config /usr/local/etc/mongod.conf"
