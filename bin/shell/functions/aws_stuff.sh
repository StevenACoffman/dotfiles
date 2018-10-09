#!/bin/bash

function aws_who_am_i() {
    aws sts get-caller-identity
}

function aws_searching_for_apps() {
    if [[ -z $1 ]]; then
        echo
        echo "Usage: $0 <name-pattern>"
        echo "To get all eureka servers in the test environment, run: $0 \"test:eureka*\""
        echo
        exit 1
    fi

    aws ec2 describe-instances --filters "Name=tag-key,Values=Name" --filters "Name=tag-value,Values=$1" | jq -r '.Reservations[].Instances[] | [ .InstanceId, .PublicDnsName, .PrivateIpAddress, .Placement.AvailabilityZone, .InstanceType, .LaunchTime, .State.Name, (.Tags[] | select(.Key=="Name")).Value ] | @csv'
}

function get_test_logs() {

    if [ $# -lt 2 ] ; then
    	echo Usage: $0 app deployment-id [substring-match]
    	return 0
    fi
    app=$1
    mkdir -p $app
    # s3cmd get --skip-existing s3://kafka-logs/prod/$1/$2/*/*$3* $app/
    aws s3 cp \
      s3://kafka-logs/test/$1/$2 $app/ \
      --region "us-east-1" \
      --recursive \
      --exclude "*" \
      --include "*/*$3*"
}

function get_prod_logs() {
    if [ $# -lt 2 ] ; then
    	echo Usage: $0 app deployment-id [substring-match]
    	return 0
    fi
    app=$1
    mkdir -p $app

    aws s3 cp \
      s3://kafka-logs/prod/$1/$2 $app/ \
      --region "us-east-1" \
      --recursive \
      --exclude "*" \
      --include "*/*$3*"
}

# Usage: aws_ssh_it ${EC2_INSTANCE_NAME}
# Example: aws_ssh_it test:search-a112
function aws_ssh_it() { ssh "$(aws_name_to_ip "$1")"; }
function aws_name_to_ip() {
        if [ -z "$VIRTUAL_ENV" ]; then
                workon aws;
        fi
        aws ec2 describe-instances --filters "Name=tag-value,Values=$1" --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' | sort;
}

function get_addr_for_id {
    address=$(aws ec2 describe-instances --instance-id $1 | jq -r '.Reservations[].Instances[] | .PrivateIpAddress')
    if [[ -z $address ]]; then
        address=$(aws ec2 describe-instances --instance-id $1 | jq -r '.Reservations[].Instances[] | .PublicDnsName')
    fi
    echo $address
}

function rds_lookup() {
    RDS_INSTANCE_IDENTIFIER="$1"
    aws rds describe-db-instances --db-instance-identifier "$RDS_INSTANCE_IDENTIFIER" --output text --query 'DBInstances[0].Endpoint.Address'
}

function list_vpcs() {
    # This seems to get the first one, not the whole list
    aws ec2 describe-vpcs --query 'Vpcs[].VpcId|[0]' --output text
}
function create_vpc_peering_connection() {
    export K8S_VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$KOPS_NAME" --output text --query 'Vpcs[].VpcId')
    if [[ -z $K8S_VPC_ID ]]; then
        echo
        echo "Please export the kubernetes vpc id as K8S_VPC_ID"
        echo
        exit 1
    fi
    if [[ -z $SEQUOIA_VPC_ID ]]; then
        echo
        echo "Please export the sequoia vpc id as SEQUOIA_VPC_ID"
        echo
        exit 1
    fi
    gopy
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    workon aws
    # omitting jmespath query for now
    #--output text --query 'VpcPeeringConnection.VpcPeeringConnectionId'
    aws ec2 create-vpc-peering-connection --peer-owner-id $AWS_ACCOUNT_ID --peer-vpc-id $SEQUOIA_VPC_ID --vpc-id $K8S_VPC_ID
}

function accept_vpc_peering_connection() {
    # https://wiki.outscale.net/display/DOCU/Getting+Information+About+Your+VPC+Peering+Connections
    export K8S_VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$KOPS_NAME" --output text --query 'Vpcs[].VpcId')
    export VPC_PEERING_CONNECTION_ID=$(aws ec2 describe-vpc-peering-connections --filters "Name=requester-vpc-info.vpc-id,Values=$K8S_VPC_ID" --output text --query 'VpcPeeringConnections[].VpcPeeringConnectionId')
    if [[ -z $VPC_PEERING_CONNECTION_ID ]]; then
        echo
        echo "Please export the vpc peering connection id as VPC_PEERING_CONNECTION_ID"
        echo
        exit 1
    fi
    gopy
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    workon aws
    aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID
}

function delete_vpc_peering_connection() {
    export K8S_VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$KOPS_NAME" --output text --query 'Vpcs[].VpcId')
    export VPC_PEERING_CONNECTION_ID=$(aws ec2 describe-vpc-peering-connections --filters "Name=requester-vpc-info.vpc-id,Values=$K8S_VPC_ID" --output text --query 'VpcPeeringConnections[].VpcPeeringConnectionId')
    if [[ -z $VPC_PEERING_CONNECTION_ID ]]; then
        echo
        echo "Please export the vpc peering connection id as VPC_PEERING_CONNECTION_ID"
        echo
        exit 1
    fi
    aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID
}

function list_cidr_blocks() {
    # replace test with prod
    aws ec2 describe-subnets --filter "Name=tag:sequoia:environment,Values=test" "Name=tag-value,Values=test-public-*" --query 'Subnets[].CidrBlock'
}

function avs() {
    unset AWS_VAULT
    VAULT_SERVER_PID=$(lsof -t -i :9099)
    if [[ -n "${VAULT_SERVER_PID:-}" ]]
    then
      kill -9 "${VAULT_SERVER_PID}"
    fi

    aws-vault remove --sessions-only\
     "${AWS_VAULT_DEFAULT_PROFILE:-core}"\
     2>&1 >/dev/null

    aws-vault exec -s "${AWS_VAULT_DEFAULT_PROFILE:-core}"\
     <<< "$(2fa aws-ithakasequoia-scoffman)"\
     2> >( sed '$d' >&2 )
     1> >( sed '$d' >&1 )
}

function avlc() {
    aws-vault remove --sessions-only\
     "${AWS_VAULT_DEFAULT_PROFILE:-core}"\
     2>&1 >/dev/null

    aws-vault login "${AWS_VAULT_DEFAULT_PROFILE:-core}"\
     <<< "$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia-scoffman})"\
     2> >( sed '$d' >&2 )\
     1> >( sed '$d' >&1 )
}

function awhoami() {
    aws sts get-caller-identity
}
