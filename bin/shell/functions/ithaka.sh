#!/bin/bash

function cuke-mylist() {
  cd ~/Documents/git/cucumber || exit 1
  bundle exec rake MyLists_Service:MyLists_Service
}

function sagoku_login() {
# https://stackoverflow.com/questions/13048954/how-to-login-to-a-spring-security-login-form-using-curl
# -S show-error if fails
# -s silent
# -k insecure
    curl -sSk --cookie-jar cookie -L 'http://sagoku.test.cirrostratus.org/j_spring_security_check' -H 'Content-Type: application/x-www-form-urlencoded'  --data '_spring_security_remember_me=true&j_username='"${SAGOKU_USERNAME}"'&j_password='"${SAGOKU_PASSWORD}" --compressed
#export SGK_APP_NAME=teller-flask
#export SGK_APP_GIT_HASH=826f99420057c118d2de03e9bc161387fce25268
#    curl -sSk --cookie cookie 'http://sagoku.test.cirrostratus.org/apps/'"{$SGK_APP_NAME}"'/rebuild.html?hash='"$SGK_APP_GIT_HASH" -X POST -H 'Content-Type: application/x-www-form-urlencoded' --compressed
}

function setds() {
  service=$1
  switch=$2
  state=${3-true}

  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  else
  	path=
  fi

  for h in $(sl $service) ; do
  	echo "$h \c"
  	curl -s -X PUT -H "Content-Type:application/json" "http://$h:8080$path/watchable/dipswitch/$switch" -d '{"bit":"'$state'"}'
  	echo ''
  done
}

function setff() {
  #
  # Usage: setff [env/]service flag state
  #
  # Set the specified flag on the service to the state.
  # If the flag name does not have a "." in it, then the KillSwitch will be set.
  # The default state value is "alive".
  #
  # Requires: curl, sl

  service=$1
  flag=$2
  if [[ $flag != *.* ]] ; then flag=$flag.KillSwitch; fi
  state=${3-alive}
  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  else
  	path=
  fi

  for h in $(sl $service) ; do
  	echo "$h \c"
  	curl -s -X PUT -H "Content-Type:application/json" "http://$h:8080$path/watchable/featureflag/$flag" -d '{"value":"'$state'"}'
  	echo ''
  done
}

function setpv() {
  #
  # Usage: setpv [env/]service[/path] variable value
  #
  # Set a persistent variable on a service to a value.
  # Sets the value only in the currently running instances. Does not update the saved value.
  #
  # If the first argument is in the form "env/service/path", adds "path" before "/watchable" in URL,
  # which is useful for running service in Eclipse, where the service has a deployment path.
  #
  # Requires sl, curl

  service=$1
  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  fi
  var=$2
  value=${3-}

  for h in $(sl $service) ; do
  	echo "$h \c"
  	curl -s -X PUT -H "Content-Type:application/json" "http://$h:8080$path/watchable/persistentvariable/$var" -d '{"value":"'$value'"}'
  	echo ''
  done
}

function showds() {
  #
  # Usage: showds [env/]service[/path] [selector]
  #
  # Show the dipswitch values for a service.
  # The second argument is a substring selector on the dipswitch names. Only matching dipswitches will be shown.
  #
  # If the first argument is in the form "env/service/path", adds "path" before "/watchable" in URL,
  # which is useful for running service in Eclipse, where the service has a deployment path.
  #
  # Requires sl, jq, curl

  service=$1
  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  else
  	path=
  fi

  selff=${2-""}
  if [[ $selff == *,* ]] ; then
  	selff=$(echo "$selff"|sed 's/[^,]*/"&"/g')
  else
  	selff='"'"$selff"'"'
  fi


  for h in $(sl $service); do
  	echo $h
  	curl -s "http://$h:8080$path/watchable/dipswitch/" | jq -c ".|to_entries|map(select((.key|contains($selff))))|sort_by(.key)|.[]|[{key,\"value\":.value.bit}]|from_entries"
  done
}

function showff() {
  #
  # Usage: showff [env/]service [selector]
  #
  # Show feature flag values for a service.
  # The second argument is a substring selector on the feature flag names. Only matching flags will be shown.
  # It defaults to "Kill" to show the kill switches. Multiple selectors can be specified, separated by commas.
  #
  # Requires sl, jq, curl

  service=$1
  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  else
  	path=
  fi

  selff=${2-"Kill"}
  if [[ $selff == *,* ]] ; then
  	selff=$(echo "$selff"|sed 's/[^,]*/"&"/g')
  else
  	selff='"'"$selff"'"'
  fi


  for h in $(sl $service); do
  	echo $h
  	curl -s "http://$h:8080$path/watchable/featureflag/"|jq -c ".|to_entries|map(select((.key|contains($selff)) and .value.value))|sort_by(.key)|.[]|[{key,\"value\":.value.value}]|from_entries"
  done
}

function showpv() {
  #
  # Usage: showpv [env/]service [selector]
  #
  # Show persistent variable values for a service.
  # The second argument is a substring selector on the PV names. Only matching PVs will be shown.
  # Multiple selectors can be specified, separated by commas.
  #
  # Requires sl, jq, curl

  service=$1
  echo "1"
  if [[ $service == */*/* ]] ; then
  	path=/$(basename $service)
  	service=$(dirname $service)
  else
  	path=
  fi
  echo "2"

  selff=${2-""}
  echo "3"
  if [[ $selff == *,* ]] ; then
  	selff=$(echo "$selff"|sed 's/[^,]*/"&"/g')
  else
  	selff='"'"$selff"'"'
  fi
  echo "4"

  for h in $(sl $service); do
  	echo $h
    PERSISTENT_VARIABLES=$(curl -L -s "http://$h:8080$path/watchable/persistentvariable/")
    echo $PERSISTENT_VARIABLES
  	jq -c ".|to_entries|map(select((.key|contains($selff)) and .value.value))|sort_by(.key)|.[]|[{key,\"value\":.value.value}]|from_entries"
  done
}

function showresp() {
  #
  # Show the response or a portion of the response to a REST query sent to each instance in a service
  #
  # Usage: showresp [env/]service url [jq-expression]

  if [ $# -lt 2 ] ; then
  	echo 'Usage: showresp [env/]service url [jq-expression]'
  	exit 0
  fi

  service=$1
  url=$2
  jqe=${3-.}

  sl $service | while read s ; do
  	echo $s
  	curl -s "$s$url" | jq "$jqe"
  done

}
function sl() {
  #
  # Usage: sl [environment=test/]service-name [index]
  #
  # Call the service locator to get the host name(s) for a particular service.
  # The default environment is "test". Specify prod/service-name to use the prod environment instead.
  # By default it returns all the instances. To get a single instance (for use in a command line, e.g.),
  # specify the index number of the desired instance as the second argument. Since instances are returned
  # in an indeterminate order, "0" works as well as any other value.
  #
  # Special values for service-name:
  #   localhost: returns "localhost" for convenience
  #   all: prints all the available service names
  #
  # Requires curl and jq.
  #
  # 2015-09-20: Now uses eureka rather than service-locater-the-service. This version
  # shows all running instances, so during a sagoku deploy can show both the "new" and "old" instances.


  if [ "$1" == "" ] ; then
  	echo "usage: sl service-name [environment=test]"
  	exit 0
  fi

  service=$1
  if [[ $service == */* ]] ; then
  	env=$(dirname $service)
  	service=$(basename $service)
  else
  	env=test
  fi

  if [ "$service" == "localhost" ] ; then
  	echo localhost
  else
  	if [ "$service" == "all" ] ; then
      EUREKA_RESULTS=$(curl -H Accept:application/json -s "http://eureka.apps.$env.cirrostratus.org/eureka/v2/apps")
      echo $EUREKA_RESULTS
  		echo $EUREKA_RESULTS| \
  			jq '.applications.application|map({name,"instances":[.instance.hostName? // (.instance[].hostName)]})|sort_by(.name)'
  	else
  		EUREKA_RESULTS=$(curl -H Accept:application/json -s "http://eureka.apps.$env.cirrostratus.org/eureka/v2/apps/$service")
      echo $EUREKA_RESULTS
  		echo $EUREKA_RESULTS|\
  			jq -r '.application|.instance.hostName? // (.instance['$2'].hostName)'
  	fi
  fi
}
