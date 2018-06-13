#!/bin/bash
#Expects you to have zookeeper jq and curl installed so:
#brew install zookeeper jq curl
ZOOKEEPER_INSTANCE=$(curl -H Accept:application/json -s "http://eureka.apps.test.cirrostratus.org/eureka/v2/apps/zookeeper"|jq -r '.application|.instance[0].hostName')
echo $ZOOKEEPER_INSTANCE
zkCli -server "$ZOOKEEPER_INSTANCE":2181 get "/sequoia/watchable/*/*/global.asset.bucket"
