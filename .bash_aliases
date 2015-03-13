alias ll="ls -l"
#alias mountmsis="if [ -d /Volumes/MSIS ]; then if [ -d /Volumes/MSIS/MSIS-Argus ]; then echo \"Already mounted\"; else mount -t smbfs #//$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi; else mkdir /Volumes/MSIS; mount -t smbfs //$LOGNAME@bluestorage.umms.med.umich.edu/UMMS-MSA/MSIS /Volumes/MSIS; fi"
#alias mountmgmt="if [ -d /Volumes/mgmt ]; then if [ -d /Volumes/mgmt/deploy ]; then echo \"Already mounted\"; else mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi; else mkdir /Volumes/mgmt; mount -t webdav https://www.umms.med.umich.edu/mgmt /Volumes/mgmt; fi"
#alias mm="date; mountmsis;"
#alias mgmt="date; mountmgmt;"
alias abramssh="ssh login.umms.med.umich.edu;"


alias startresin="/usr/local/resin/bin/resin_funcs.sh start first; /usr/local/resin/bin/resin_funcs.sh log first"
alias startdebugresin="/usr/local/resin/bin/resin_funcs.sh debug first; /usr/local/resin/bin/resin_funcs.sh log first"
alias resinlog="/usr/local/resin/bin/resin_funcs.sh log first"
alias stopresin="/usr/local/resin/bin/resin_funcs.sh stop first"
alias sr="startresin"
alias str="stopresin"

alias startresinserver="/usr/local/resin/bin/resin_funcs.sh startserver; /usr/local/resin/bin/resin_funcs.sh serverlog"
alias resinserverlog="/usr/local/resin/bin/resin_funcs.sh serverlog"
alias stopresinserver="/usr/local/resin/bin/resin_funcs.sh stopserver"

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
#resin test = acumen =
alias resintest="ssh 192.168.123.55"
alias resinstaging="ssh martin"
alias sthuban="ssh -t abram 'ssh thuban;'"
alias smenkar="ssh -t abram 'ssh menkar;'"

alias ssgrus="echo 'Must be running F5 vpn to succeed' && ssh 192.168.123.61"
alias ssacumen="ssh 192.168.123.55"
alias ssmenkar="ssh 192.168.123.56"
alias ssthuban="ssh 192.168.123.57"
#tomcat 10.16.26.63
alias sstomcat="ssh tomcat1-test.med.umich.edu"
alias sstest="ssh tomcat1-test.med.umich.edu"
alias ssstaging="ssh tomcat1-staging.med.umich.edu"
#tomcat1-prod.med.umich.edu
alias ssprod="ssh 10.16.26.65"
alias ssjenkins="ssh 192.168.123.61 || echo Run f5 first"
alias ssgrus="ssh 192.168.123.61 || echo Run f5 first"

alias tsd="/usr/local/opt/tomcat/libexec/bin/shutdown.sh -force"
alias tsu="/usr/local/opt/tomcat/libexec/bin/startup.sh"
alias tsr="tsd && tsu"
alias debug="tsd || true && /usr/local/opt/tomcat/libexec/bin/catalina.sh jpda start"
alias gojs="cd ~/Documents/js"
alias goweb="cd ~/Documents/git/assessment_services/web/src/main/webapp/WEB-INF"
alias sm="mongod --config /usr/local/etc/mongod.conf"
