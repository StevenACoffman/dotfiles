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

function maven-graph-deps() {
  #brew install graphviz
  mvn org.kuali.maven.plugins:graph-maven-plugin:dependencies -Dgraph.includes=org.cirrostratus*,org.ithaka*
  open target/graph/
}

function mylists() {
#sagoku_region=us-east-1
#sagoku_service=titlelist-service
#servicelocator_ping=300
#sagoku_hostname=localhost
#AWS_ACCESS_KEY_ID=YOUR_KEY
#DISABLE_LEGACY_SERVICE_LOCATOR=please
#AWS_SECRET_KEY=YOUR_KEY
#sagoku_domain=cirrostratus.org
#sagoku_environment=test
#sagoku_index=01
export SGK_ENVIRONMENT=test
export sagoku_service=my-lists
export sagoku_index=01
export sagoku_name=$sagoku_service$sagoku_index
export sagoku_environment=test
export sagoku_domain=cirrostratus.org
export sagoku_hostname=$sagoku_service$sagoku_index.$sagoku_environment.$sagoku_domain
export sagoku_region=us-east-1
export servicelocator_ping=300
export DISABLE_LEGACY_SERVICE_LOCATOR=true
  cd /Users/scoffman/Documents/git/mylists-service || exit 1
  mvn tomcat7:run -Dmaven.tomcat.port=8181 -Dsagoku_service=my-lists -Dsagoku_domain=cirrostratus.org -Dsagoku_environment=test -Dsagoku_index=99
}

function personalization-service() {
#sagoku_region=us-east-1
#sagoku_service=titlelist-service
#servicelocator_ping=300
#sagoku_hostname=localhost
#AWS_ACCESS_KEY_ID=YOUR_KEY
#DISABLE_LEGACY_SERVICE_LOCATOR=please
#AWS_SECRET_KEY=YOUR_KEY
#sagoku_domain=cirrostratus.org
#sagoku_environment=test
#sagoku_index=01
  cd /Users/scoffman/Documents/git/personalization-service/iac-ucm || exit 1
  mvn tomcat7:run -Dmaven.tomcat.port=8282 -Dsagoku_service=my-lists -Dsagoku_domain=cirrostratus.org -Dsagoku_environment=test -Dsagoku_index=99
}



function mvnt() {
  # This makes maven generate reasonable html test reports
  mvn test
  mvn surefire-report:report-only
  mvn site -DgenerateReports=false
}


function cleanLiquibaseProperties() {
  old_cwd=${PWD}
  cd "$GIT_ROOT_DIR/assessment_services"
  git checkout -- liquibase/liquibase.dev.properties
  cd "$GIT_ROOT_DIR/assessment_framework"
  git checkout -- liquibase/liquibase.dev.properties
  cd "$old_cwd"
}
function restoreLiquibaseProperties() {
  cp ~/.amadeus/liquibase.dev.properties "$GIT_ROOT_DIR/assessment_services/liquibase/liquibase.dev.properties"
  cp ~/.amadeus/liquibase.dev.properties "$GIT_ROOT_DIR/assessment_framework/liquibase/liquibase.dev.properties"
}
function releaseLocks() {
  restoreLiquibaseProperties
  old_cwd=${PWD}
  cd "$GIT_ROOT_DIR/assessment_services/liquibase"
  mvn -Denv=dev -Ddatabase=dev liquibase:releaseLocks
  cd "$GIT_ROOT_DIR/assessment_framework/liquibase"
  mvn -Denv=dev -Ddatabase=dev liquibase:releaseLocks
  cd "$old_cwd"
  cleanLiquibaseProperties
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
  restoreLiquibaseProperties
	#cd ${GIT_ROOT_DIR}/coreservices/liquibase
	#mvn liquibase:update -Ddatabase=dev
	cd ${GIT_ROOT_DIR}/assessment_framework/liquibase
	mvn liquibase:update -Ddatabase=${TIER}
	cd ${GIT_ROOT_DIR}/assessment_services/liquibase
	mvn liquibase:update -Ddatabase=dev
  cleanLiquibaseProperties
	cd "$old_cwd"
}
function mavenCleanInstall() {
	echo "Running maven clean install for tier ${TIER}"
  restoreLiquibaseProperties
	mvn -Denv=${TIER} -Ddatabase=${TIER} clean install && redeployTomcat
  cleanLiquibaseProperties
}
function mavenCleanInstallAll() {
  restoreLiquibaseProperties
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
  restoreLiquibaseProperties
	mvn -Denv=${TIER} -Ddatabase=${TIER} -DskipITs=true -Djetty.skip=true clean install && redeployTomcat
  cleanLiquibaseProperties
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

function popupWarning() {

/usr/bin/osascript > /dev/null <<EOT
tell application "System Events"
	display dialog "Warning: $1"
end tell
EOT
}

function csrdp() {
  cd "${GIT_ROOT_DIR}/coreservices"
  redeployTomcat
}
function afrdp() {
  cd "${GIT_ROOT_DIR}/assessment_framework"
  redeployTomcat
}
function asrdp() {
  cd "${GIT_ROOT_DIR}/assessment_services"
  redeployTomcat
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
