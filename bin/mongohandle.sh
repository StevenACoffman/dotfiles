#!/bin/bash
#mongod=/usr/local/bin/mongod

mongod=mongod
#mongod_data=/Users/michito/work/mongodb_data
#mongod_log=/Users/michito/work/mongodb_log/mongodb.log
mongod_conf=/usr/local/etc/mongod.conf
prog=mongohandle.sh
RETVAL=0

stop() {
  grep_mongo=$(ps aux | grep -v grep | grep "${mongod}")
  if [ ${#grep_mongo} -gt 0 ]
    then
    echo "Stop MongoDB."
    PID=$(ps x | grep -v grep | grep "${mongod}" | awk '{ print $1 }')
    kill -2 "${PID}"
    RETVAL=$?
  else
    echo "MongoDB is not running."
  fi
}
start() {
  grep_mongo=$(ps aux | grep -v grep | grep "${mongod}")
  if [ -n "${grep_mongo}" ]
    then
    echo "MongoDB is already running."
  else
    echo "Start MongoDB."
    echo "${mongod} --config ${mongod_conf} --fork"
    ${mongod} --config ${mongod_conf} --fork
# original code follows
#    $(${mongod} --dbpath ${mongod_data} --logpath ${mongod_log} --fork --logappend)
    RETVAL=$?
  fi
}

case "$1" in
  start)
  start
  ;;
  stop)
  stop
  ;;
  restart)
  stop
  start
  ;;
  *)
  echo $"Usage: $prog {start|stop|restart}"
  exit 1
esac

exit $RETVAL
