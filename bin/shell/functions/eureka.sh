#!/bin/bash
function eureka-list() {
  # curl -s silent
  # jq -r raw output
  curl -H Accept:application/json -s \
  "http://eureka.apps.${2:-test}.cirrostratus.org/eureka/v2/apps/${1:-mylists-service}" | \
   jq -r '.application|(if ([.instance|arrays]|length>0) then .instance|map(select(.status=="UP")|.hostName) else [.instance|select(.status=="UP")|.hostName]  end)[]'
}

function get_kafka_brokers() {
    SGK_ENVIRONMENT=${1:-test};curl -s -H 'Accept: application/json' http://eureka.${SGK_ENVIRONMENT}.cirrostratus.org/eureka/v2/apps/kafka |    jq -r         '[.application.instance |
        if (. | arrays | length) // (-1) >= 0 then .[]
        else .
        end |
        select(.hostName != null) |
        .hostName + ":9092"] | join(",")'
}

function get_zookeeper_nodes() {
    SGK_ENVIRONMENT=${1:-test};curl -s -H 'Accept: application/json' http://eureka.${SGK_ENVIRONMENT}.cirrostratus.org/eureka/v2/apps/zookeeper |    jq -r         '[.application.instance |
        if (. | arrays | length) // (-1) >= 0 then .[]
        else .
        end |
        select(.hostName != null) |
        .hostName + ":2181"] | join(",")'
}


function list_eureka_instances(){
# Script to discover and list instances based on a eureka service name
# Use this script to discover the IP to SSH to for a given deployment
# Usage example:   list_eureka_instances.sh mylists-service test

    if [[ -z $1 ]]
    then
        echo "Please specify an app service name as an argument"
        echo
        return 1
    fi
    APP=$(echo $1 | tr '[:upper:]' '[:lower:]')
    ENVIRONMENT=${2:-test}

    #Verify we have installed dependencies
    hash jq 2> /dev/null || {
        echo "Please make sure jq is installed and in your path"
        return 1
    }

    hash curl 2> /dev/null || {
        echo "Please make sure curl is installed and in your path"
        return 1
    }

    echo "Looking up eureka registry for ${APP} in ${ENVIRONMENT}"
    echo "HostName Port Status Instance-id"
    curl -s -H 'Accept: application/json' "http://eureka.${ENVIRONMENT}.cirrostratus.org/eureka/v2/apps/${APP}" |\
    jq -r \
        '.application.instance |
        if (. | arrays | length) // (-1) >= 0 then .[]
        else .
        end |
        select(.hostName != null) |
        .hostName+ " " + (.port["$"] | tostring) + " " + .status + " " + .dataCenterInfo.metadata["instance-id"]'

}
