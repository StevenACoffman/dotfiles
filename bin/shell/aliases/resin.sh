#!/bin/bash

# resin bash_aliases

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
