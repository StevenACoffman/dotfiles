#!/bin/bash
#    ______                           __     __  __          __      __
#   /_  __/___  ____ ___  _________ _/ /_   / / / /___  ____/ /___ _/ /____
#    / / / __ \/ __ `__ \/ ___/ __ `/ __/  / / / / __ \/ __  / __ `/ __/ _ \
#   / / / /_/ / / / / / / /__/ /_/ / /_   / /_/ / /_/ / /_/ / /_/ / /_/  __/
#  /_/  \____/_/ /_/ /_/\___/\__,_/\__/   \____/ .___/\__,_/\__,_/\__/\___/
#                                             /_/
# Written by Steve Coffman (gears) because why do something twice.

BASE_PATH=/usr/local/Cellar/tomcat
TOMCAT_VERSIONS=($(ls -lt $BASE_PATH |grep ^d | awk '{print $9}'))

NUMBER_OF_TOMCATS=${#TOMCAT_VERSIONS[@]}
if [ ${NUMBER_OF_TOMCATS} -lt 2 ]; then
    echo "There are less than two versions of tomcat (${NUMBER_OF_TOMCATS} versions.)"
    exit 0
fi
NEW_TOMCAT=${TOMCAT_VERSIONS[0]}
OLD_TOMCAT=${TOMCAT_VERSIONS[1]}

if [ ! -f "$BASE_PATH/$NEW_TOMCAT/libexec/bin/setenv.sh" ]; then
  echo "copying setenv to $BASE_PATH/$NEW_TOMCAT/libexec/bin/setenv.sh"
  cp $BASE_PATH/$OLD_TOMCAT/libexec/bin/setenv.sh $BASE_PATH/$NEW_TOMCAT/libexec/bin
  cp $BASE_PATH/$OLD_TOMCAT/libexec/lib/activation-1.1.1.jar $BASE_PATH/$NEW_TOMCAT/libexec/lib
  cp $BASE_PATH/$OLD_TOMCAT/libexec/lib/log4j.properties $BASE_PATH/$NEW_TOMCAT/libexec/lib
  cp $BASE_PATH/$OLD_TOMCAT/libexec/lib/mail-1.4.7.jar $BASE_PATH/$NEW_TOMCAT/libexec/lib
  cp $BASE_PATH/$OLD_TOMCAT/libexec/lib/ojdbc6.jar $BASE_PATH/$NEW_TOMCAT/libexec/lib
  #Back up default files from new version
  cp $BASE_PATH/$NEW_TOMCAT/libexec/conf/context.xml $BASE_PATH/$NEW_TOMCAT/libexec/conf/context.xml.bak
  cp $BASE_PATH/$NEW_TOMCAT/libexec/conf/tomcat-users.xml $BASE_PATH/$NEW_TOMCAT/libexec/conf/tomcat-users.xml.bak
  cp $BASE_PATH/$OLD_TOMCAT/libexec/conf/context.xml $BASE_PATH/$NEW_TOMCAT/libexec/conf
  cp $BASE_PATH/$OLD_TOMCAT/libexec/conf/tomcat-users.xml $BASE_PATH/$NEW_TOMCAT/libexec/conf
  for WARFILE in $BASE_PATH/$OLD_TOMCAT/libexec/webapps/*.war; do
    cp "$WARFILE" $BASE_PATH/$NEW_TOMCAT/libexec/webapps/
  done
fi
