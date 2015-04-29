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
GIT_ROOT_DIR=~/Documents/git

#!/bin/bash

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
        mvn -Dmaven.test.skip=true -DskipTests=true -Denv=${TIER} -Ddatabase=${TIER} -Djetty.skip=true -Dmaven.install.skip=true tomcat7:redeploy
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
	cd ${GIT_ROOT_DIR}/alias && \
	redeployTomcat && \
	cd ${GIT_ROOT_DIR}/coreservices && \
	redeployTomcat && \
	cd ${GIT_ROOT_DIR}/assessment_framework && \
	redeployTomcat && \
	cd ${GIT_ROOT_DIR}/assessment_services && \
	redeployTomcat && \
	cd "$old_cwd"
}
function reliquibase() {
	old_cwd=${PWD}
	echo "Running Liquibase for Assessment Framework for tier ${TIER}"
	#cd ${GIT_ROOT_DIR}/coreservices/liquibase
	#mvn liquibase:update -Ddatabase=dev
	cd ${GIT_ROOT_DIR}/assessment_framework/liquibase
	mvn liquibase:update -Ddatabase=${TIER}
	#cd ${GIT_ROOT_DIR}/assessment_services/liquibase
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
	cd ${GIT_ROOT_DIR}/alias && \
	mavenCleanInstall && \
	cd ${GIT_ROOT_DIR}/coreservices && \
	mavenCleanInstall && \
	cd ${GIT_ROOT_DIR}/assessment_framework && \
	mavenCleanInstall && \
	cd ${GIT_ROOT_DIR}/assessment_services && \
	mavenCleanInstall && \
	cd "$old_cwd" && \
	popupWarning 'Maven Clean Install Complete'
}
function noTestsBuild() {
	echo "Running no tests build for tier ${TIER}"
	mvn -Denv=${TIER} -Ddatabase=${TIER} -DskipITs=true -Djetty.skip=true clean install && redeployTomcat
}
function noTestsBuildAll() {
	reliquibase
	old_cwd=${PWD}
	echo "Old directory is ${old_cwd}"
	cd ${GIT_ROOT_DIR}/alias && \
		noTestsBuild && \
		cd ${GIT_ROOT_DIR}/coreservices && \
		noTestsBuild && \
		cd ${GIT_ROOT_DIR}/assessment_framework && \
		noTestsBuild && \
		cd ${GIT_ROOT_DIR}/assessment_services && \
		noTestsBuild && \
		echo "$old_cwd" && \
		cd "$old_cwd" && \
		popupWarning "Rebuild All Complete"
}
function doESS() {
  PWD=$(pwd)
  echo "starting in $PWD"
  cd ~
  buildDir="${GIT_ROOT_DIR}/examscore"
  cd "$buildDir"
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

function csntb() {
  cd "${GIT_ROOT_DIR}/coreservices"
  noTestsBuild
}
function afntb() {
  cd "${GIT_ROOT_DIR}/assessment_framework"
  noTestsBuild
}
function asntb() {
  cd "${GIT_ROOT_DIR}/assessment_services"
  noTestsBuild
}

function csmci() {
  cd "${GIT_ROOT_DIR}/coreservices"
  mavenCleanInstall
}
function afmci() {
  cd "${GIT_ROOT_DIR}/assessment_framework"
  mavenCleanInstall
}
function asmci() {
  cd "${GIT_ROOT_DIR}/assessment_services"
  mavenCleanInstall
}
docker-ip() {
  boot2docker ip 2> /dev/null
}
