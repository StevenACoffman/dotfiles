alias ll="ls -l"
#alias mountmsis="if [ -d /Volumes/MSIS ]; then if [ -d /Volumes/MSIS/MSIS-Argus ]; then echo \"Already mounted\"; else mount -t smbfs #//$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi; else mkdir /Volumes/MSIS; mount -t smbfs //$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi"
#alias mountmgmt="if [ -d /Volumes/mgmt ]; then if [ -d /Volumes/mgmt/deploy ]; then echo \"Already mounted\"; else mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi; else mkdir /Volumes/mgmt; mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi"
#alias mm="date; mountmsis;"
#alias mgmt="date; mountmgmt;"
alias abramssh="ssh login.umms.med.umich.edu;"

#alias startresin="/usr/local/resin/bin/resin_funcs.sh start; /usr/local/resin/bin/resin_funcs.sh log"
#alias resinlog="/usr/local/resin/bin/resin_funcs.sh log"
#alias stopresin="/usr/local/resin/bin/resin_funcs.sh stop"
#alias sr="startresin"
#alias str="stopresin"

#alias startresinserver="/usr/local/resin/bin/resin_funcs.sh startserver; /usr/local/resin/bin/resin_funcs.sh serverlog"
#alias resinserverlog="/usr/local/resin/bin/resin_funcs.sh serverlog"
#alias stopresinserver="/usr/local/resin/bin/resin_funcs.sh stopserver"

#alias dmf="date; ant aaa.do.me.first;"
#alias dp="cd /devel/projects"
#alias dd="date; ant deploy-dev;"
#alias deploytest='date; mgmt; ant test.war; for i in *.war; do `cp "$i" $RD1/"${i/test.}"`; done;'
#alias mdd="date; mvn war:exploded"
#alias mwar="date; mvn package"

#alias rdp="mvn -DskipTests=true tomcat7:redeploy"
#alias mci="mvn -Denv=${TIER} clean install"
#alias ntb="mvn -Denv=${TIER} -DskipTests=true clean install"

#alias cw="cd .webapp"
#alias csr="cw; sr"
#alias rd1="if [ -d /Volumes/mgmt-1 ]; then cd /Volumes/mgmt-1/deploy/resin_dev_1; else cd /Volumes/mgmt/deploy/resin_dev_1; fi"
#alias rs0="if [ -d /Volumes/mgmt-1 ]; then cd /Volumes/mgmt-1/deploy/resin_staging_0; else cd /Volumes/mgmt/deploy/resin_staging_0; fi"
#alias rp0="cd /Volumes/MSIS/MSIS-Argus/MSIS\ Transfer/WAR\ Transfer/resin_prod0;"

alias sacumen="ssh -t abram 'ssh acumen;'"
alias sthuban="ssh -t abram 'ssh thuban;'"
alias smenkar="ssh -t abram 'ssh menkar;'"

alias ssacumen="ssh 192.168.123.55"
alias ssmenkar="ssh 192.168.123.56"
alias ssthuban="ssh 192.168.123.57"
alias ssjenkins="ssh 192.168.123.61 || echo You need to run f5 first"
