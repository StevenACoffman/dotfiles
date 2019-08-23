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

function list_subnets() {
    aws ec2 describe-subnets --query 'Subnets[?Tags[?Key==`sequoia:environment`]|[?Value==`acorn`]].SubnetId'
}

function list_secgrp() {
    aws ec2 describe-security-groups --query 'SecurityGroups[?Tags[?Key==`sequoia:environment`]|[?Value==`acorn`]].GroupId'
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
    while [ 1 ]
    do
        unset AWS_VAULT
        VAULT_SERVER_PID=$(lsof -t -i :9099)
        if [[ -n "${VAULT_SERVER_PID:-}" ]]
        then
          echo "aws-vault server is already running, so attempting to kill, password may be required"
          kill -9 "${VAULT_SERVER_PID}"
          sudo killall aws-vault
        else
            echo "Nothing running listening to 9099"
        fi

        ACTIVE_SESSION="$(aws-vault list --sessions)"
        if [[ -n "${TOTP:-}" ]]
        then
        echo "Removing stale session"
        aws-vault remove --sessions-only\
         "${AWS_VAULT_DEFAULT_PROFILE:-engineer}"\
         2>&1 >/dev/null
        fi

         export TOTP="$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia})"
         if [[ -n "${TOTP:-}" ]]
         then
           echo "Attempting to renew session with MFA OTP"
           # 3540 seconds = 59 minutes
           timeout3 -t 3540 aws-vault --debug exec --mfa-token=${TOTP} -s "${AWS_VAULT_DEFAULT_PROFILE:-engineer}"
         else
             echo "No MFA TOTP! 2fa did not find a MFA TOTP."
         fi

         VAULT_SERVER_PID=$(lsof -t -i :9099)
         if [[ -n "${VAULT_SERVER_PID:-}" ]]
         then
           echo "Vault Server is still running but somewhere else"
         else
           echo "Vault Server Killed"
         fi
     done
}


function avlc() {
    export TOTP="$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia})"
    aws-vault login --mfa-token=${TOTP} "${AWS_VAULT_DEFAULT_PROFILE:-engineer}"
}

function avlc_core() {
    export AWS_VAULT_DEFAULT_PROFILE=core
    avlc
}

function avs_core() {
    export AWS_VAULT_DEFAULT_PROFILE=core
    avs
}


function avlc_labs() {
    export AWS_VAULT_DEFAULT_PROFILE=labs
    avlc
}

function avs_labs() {
    export AWS_VAULT_DEFAULT_PROFILE=labs
    avs
}

function avkill {
    sudo killall aws-vault
}

# function avlc() {
#     aws-vault remove --sessions-only\
#      "${AWS_VAULT_DEFAULT_PROFILE:-engineer}"\
#      2>&1 >/dev/null
#
#     aws-vault login "${AWS_VAULT_DEFAULT_PROFILE:-engineer}"\
#      <<< "$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia-scoffman})"\
#      2> >( sed '$d' >&2 )\
#      1> >( sed '$d' >&1 )
# }

function awhoami() {
    /usr/local/bin/aws sts get-caller-identity
}

function aresync() {
    # If a user's device is not synchronized when they try to use it,
    # the user's sign-in attempt fails and IAM prompts the user to
    # resynchronize the device.
    AWS_MY_USERNAME=${AWS_MY_USERNAME:-$(/usr/local/bin/aws iam get-user --output text --query 'User.UserName'}

    totp1="$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia})"; totp2="${totp1}"; while [ "${totp1}" == "${totp2}" ]; do totp2="$(2fa ${AWS_MFA_NAME:-aws-ithakasequoia})"; echo "${totp2}"; sleep 1; done
    # aws-vault exec --no-session ithakasequoia -- /usr/local/bin/aws iam list-virtual-mfa-devices
    aws-vault exec --no-session ithakasequoia -- /usr/local/bin/aws iam resync-mfa-device \
    --user-name "${AWS_MY_USERNAME}" \
    --serial-number "arn:aws:iam::594813696195:mfa/${AWS_MY_USERNAME}" \
    --authentication-code1 "${totp1}" \
    --authentication-code2 "${totp2}"
}

function iam_groot() {
    echo aws iam add-user-to-group --user-name "${AWS_MY_USERNAME}" --group-name "${AWS_ADMIN_GROUP}"
}

function iam_not_groot() {
    AWS_CLI_PATH="${AWS_CLI_PATH:-/usr/local/bin}"
    "${AWS_CLI_PATH}/aws" iam remove-user-from-group --user-name "${AWS_MY_USERNAME}" --group-name "${AWS_ADMIN_GROUP}"
}

function iam_who_iam() {
    export AWS_ACCOUNT_ID="281318675473"
    export AWS_DEFAULT_PROFILE=${1:-"personalhelper"}
    export AWS_MFA_NAME="aws-edgewiseinannarbor"
    TOTP="$(2fa ${AWS_MFA_NAME})"
    aws-vault exec scoffman --mfa-token=${TOTP} -- /usr/local/bin/aws sts get-caller-identity
}
