#!/bin/bash


# Send a metric to statsd from bash
#
# Useful for:
#   deploy scripts (http://codeascraft.etsy.com/2010/12/08/track-every-release/)
#   init scripts
#   sending metrics via crontab one-liners
#   sprinkling in existing bash scripts.
#
# netcat options:
#   -w timeout If a connection and stdin are idle for more than timeout seconds, then the connection is silently closed.
#   -u         Use UDP instead of the default option of TCP.
#
function send_metric_to_statsd () {
    # carbon port 2003
export GRAPHITE_HOST=localhost
export STATSD_PORT=8125
export MESSAGE=product.message.job.created
echo "${MESSAGE}:1|c" | nc -w 1 -u "${GRAPHITE_HOST}" "${STATSD_PORT}"

#echo "test.ale-management-service-awn.ale-management-service-awn01.counters.product.message.job.created.count:$RANDOM|c" | nc -w 1 -u "${GRAPHITE_HOST}" "${STATSD_PORT}"
echo "product.message.job.created:1|c" | nc -w 1 -u "${GRAPHITE_HOST}" "${STATSD_PORT}"
# brew install socat
# echo "product.message.job.created:1|c" | socat -t 0 STDIN "UDP:${GRAPHITE_HOST}:${STATSD_PORT}"
    #statements
}
