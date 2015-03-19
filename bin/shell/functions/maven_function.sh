#!/bin/bash
#
# this script should not be run directly,
# instead you need to source it from your .bashrc,
# by adding this line:
#   . ~/bin/bash_functions.sh
#

# Includes error trapping functions

#TIER=test
TIER=dev

#!/bin/bash

function gogit() {
  echo "Changing to git directory..."
  cd ~/Documents/git
}

function gosvn() {
  echo "Changing to svn directory..."
  cd ~/Documents/svn
}

function golog() {
  echo "Changing to Tomcat log directory..."
  cd /usr/local/opt/tomcat/libexec/logs
}

function mvnci()
{
  mci
}

function mvnwrd()
{
  rdp
}

function rdp() {
	redeployTomcat
}
function rdpa() {
	redeployTomcatAll || popupWarning 'Unable to redeploy all'
}
function mci() {
	mavenCleanInstall || popupWarning 'Unable to build'
}
function mcia() {
	mavenCleanInstallAll || popupWarning 'Unable to build all'
}
function ntb() {
	noTestsBuild || popupWarning 'Unable to build all'
}
function ntba() {
	noTestsBuildAll || popupWarning 'Unable to build all'
}

function redeployTomcat() {
	old_cwd=${PWD}
	cwd_top=${PWD##*/}
	echo "Redeploying from directory ${cwd_top} for tier ${TIER}"
	if [ "$cwd_top" = 'web' ]; then
        mvn -DskipTests=true -Denv=${TIER} -Ddatabase=${TIER} -Djetty.skip=true -Dmaven.install.skip=true tomcat7:redeploy
	else
		if [ "$cwd_top" = "alias" -o "$cwd_top" = "assessment_services" -o "$cwd_top" = "assessment_framework" -o "$cwd_top" = "coreservices" ]; then
			cd web
	    mvn -DskipTests=true -Denv=${TIER} -Ddatabase=${TIER} -Djetty.skip=true -Dmaven.install.skip=true tomcat7:redeploy
			cd "$old_cwd"
		fi
	fi
}

function redeployTomcatAll() {
	old_cwd=${PWD}
	cd ~/Documents/git/alias && \
	redeployTomcat && \
	cd ~/Documents/git/coreservices && \
	redeployTomcat && \
	cd ~/Documents/git/assessment_framework && \
	redeployTomcat && \
	cd ~/Documents/git/assessment_services && \
	redeployTomcat && \
	cd "$old_cwd"
}
function reliquibase() {
	old_cwd=${PWD}
	echo "Running Liquibase for Assessment Framework for tier ${TIER}"
	#cd ~/Documents/git/coreservices/liquibase
	#mvn liquibase:update -Ddatabase=dev
	cd ~/Documents/git/assessment_framework/liquibase
	mvn liquibase:update -Ddatabase=${TIER}
	#cd ~/Documents/git/assessment_services/liquibase
	#mvn liquibase:update -Ddatabase=dev
	cd "$old_cwd"
}
function mavenCleanInstall() {
	echo "Running maven clean install for tier ${TIER}"
	mvn -Denv=${TIER} -Ddatabase=${TIER} clean install && redeployTomcat
}
function mavenCleanInstallAll() {
	reliquibase
	old_cwd=${PWD}
	cd ~/Documents/git/alias && \
	mavenCleanInstall && \
	cd ~/Documents/git/coreservices && \
	mavenCleanInstall && \
	cd ~/Documents/git/assessment_framework && \
	mavenCleanInstall && \
	cd ~/Documents/git/assessment_services && \
	mavenCleanInstall && \
	cd "$old_cwd" && \
	popupWarning 'Maven Clean Install Complete'
}
function noTestsBuild() {
	echo "Running no tests build for tier ${TIER}"
	mvn -Denv=${TIER} -Ddatabase=${TIER} -DskipTests=true -Djetty.skip=true clean install && redeployTomcat
}
function noTestsBuildAll() {
	reliquibase
	old_cwd=${PWD}
	echo "Old directory is ${old_cwd}"
	cd ~/Documents/git/alias && \
		noTestsBuild && \
		cd ~/Documents/git/coreservices && \
		noTestsBuild && \
		cd ~/Documents/git/assessment_framework && \
		noTestsBuild && \
		cd ~/Documents/git/assessment_services && \
		noTestsBuild && \
		echo "$old_cwd" && \
		cd "$old_cwd" && \
		popupWarning "Rebuild All Complete"
}
function doESS() {
  PWD=$(pwd)
  echo "starting in $PWD"
  cd ~
  buildDir="Documents/git/examscore"
  cd ~/"$buildDir"
  rm -r -f target
  mvn clean package
  cd target
  warFileName=(*.war)
  if [ ${#warFileName[@]} -ne 1 ]; then
    echo "WARNING: More than one .war file found. Not sure which to deploy."
    exit 1
  elif [[ "${warFileName[0]}" == "*.war" ]]; then
    echo "WARNING: No war files found. Not proceeding to deploy."
    exit 1
  fi


  #Getting portion of filename preceding last dash e.g. medstat-1.3.2.war -> medstat
  #WARNING an app with two dashes in the discarded portion may be wrong e.g. med-stat-1.3.4.war -> med-stat, medstat-1.3.2-b.war -> medstat-1.3.2

  #Discard version (e.g. "-1.3.2.war")
  appName="${warFileName[0]%.*}"
  echo "$appName"
  cd "$appName"
  PWD=$(pwd)
  echo "ending in $PWD"
  #/usr/local/resin/bin/resin_funcs.sh startserver
  #/usr/local/resin/bin/resin_funcs.sh serverlog
}
function popupWarning() {

/usr/bin/osascript > /dev/null <<EOT
tell application "System Events"
	display dialog "Warning: $1"
end tell
EOT
}

docker-ip() {
  boot2docker ip 2> /dev/null
}
