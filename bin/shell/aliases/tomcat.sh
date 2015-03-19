#!/bin/bash

# tomcat bash_aliases
alias stomcat="ssh tomcat1-test"
alias stest="ssh tomcat1-test"
alias sstaging="ssh tomcat1-staging"
alias sprod="ssh tomcat1-prod"


alias tsd="/usr/local/opt/tomcat/libexec/bin/shutdown.sh -force"
alias tsu="/usr/local/opt/tomcat/libexec/bin/startup.sh"
alias tsr="tsd && tsu"
alias debug="tsd || true && /usr/local/opt/tomcat/libexec/bin/catalina.sh jpda start"

alias goweb="cd ~/Documents/git/assessment_services/web/src/main/webapp/WEB-INF"
alias golog="cd /usr/local/opt/tomcat/libexec/logs"
