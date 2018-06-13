#!/bin/bash

function bless_me() {
    # To set up:
    # mkdir -p $HOME/Documents/git
    # cd $HOME/Documents/git
    # git clone git@github.com:ithaka/continuous-deployment.git
    # mkvirtualenv 2.7 venv-bless
    # workon venv-bless
    # pip install --ignore-installed six boto3 kmsauth
    BLESS_DIR="$HOME/Documents/git/continuous-deployment/bless_client"
    pyenv deactivate &>/dev/null
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    gopy
    workon venv-bless

    if [ $# -eq 1 ]; then
        echo "Usage: $0 [host_to_login test|prod [command]]"
        return 1
    fi

    RSA_KEY_FILE="$HOME/.ssh/bless_rsa"
    PUBLIC_KEY="${RSA_KEY_FILE}.pub"
    BLESS_CERT="${RSA_KEY_FILE}-cert.pub"

    # hard code to 38.68.67.196 to get to non-vpc
    SOURCE_IP=$(ifconfig "$(route get 172.28.0.0 | awk '/interface: / {print $2}')" | awk '/inet / {print $2}')
    #SOURCE_IP=38.68.67.196
    if [ -f "${BLESS_CERT}" ]; then
        cert_time=$(ssh-keygen -L -f "${BLESS_CERT}" | grep "Valid:" | awk '{print $NF}')
        certtime=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${cert_time}" "+%s")
        currenttime=$(date +%s)

        ip_from_cert=$(ssh-keygen -L -f "${BLESS_CERT}" | grep "source-address" | awk '{print $2}')
        if [[ ( "${currenttime}" -ge "${certtime}" ) || ( "${ip_from_cert}" != "${SOURCE_IP}" ) ]]; then
            ssh-add -d $RSA_KEY_FILE 2>/dev/null
            $BLESS_DIR/bless_client.py ${SOURCE_IP} ${PUBLIC_KEY} ${BLESS_CERT}
            if [ -f "${BLESS_CERT}" ]; then
                ssh-add -t 14440 $RSA_KEY_FILE
            fi
        fi
    elif [ ! -f "${BLESS_CERT}" ]; then

        if [ ! -f ${RSA_KEY_FILE} ]; then
            ssh-keygen -f ${RSA_KEY_FILE} -b 4096 -t rsa -N ''
        fi
        ssh-add -d $RSA_KEY_FILE 2>/dev/null
        $BLESS_DIR/bless_client.py ${SOURCE_IP} ${PUBLIC_KEY} ${BLESS_CERT}
        #SOURCE_IP: The source IP where the SSH connection will be initiated from

        #PUBLIC_KEY to sign: The id_rsa.pub that will be used in the SSH request.  This is
        #enforced in the issued certificate.

        #BLESS_CERT: The file where the certificate should be saved.  Per man SSH(1):
        #"ssh will also try to load certificate information from the filename
        #obtained by appending -cert.pub to identity filenames" e.g.  the <id_rsa.pub to sign>.


        if [ -f "${BLESS_CERT}" ]; then
            ssh-add -t 14440 $RSA_KEY_FILE
        fi
    fi

    pyenv deactivate &>/dev/null
}

function bless_ssh() {
    bless_me
    RSA_KEY_FILE="$HOME/.ssh/bless_rsa"
    ssh-keygen -R "$1" 2>/dev/null
    # Removes all keys belonging to hostname from a known_hosts file. This option is useful to delete hashed hosts (see the -H option above).
    ssh -o "IdentitiesOnly=yes" \
        -o "UserKnownHostsFile=/dev/null" \
        -o "StrictHostKeyChecking=no" \
        -i ${RSA_KEY_FILE} "ubuntu@$1"
}

function bless_tunnel() {
    REMOTE_LOCAL_PORT=${2:-"4194"}
    HOST_LOCAL_PORT=${3:-"9000"}
    echo "SSH Tunneling from Host Local ${HOST_LOCAL_PORT} to Remote $1:${REMOTE_LOCAL_PORT}"
    bless_me
    RSA_KEY_FILE="$HOME/.ssh/bless_rsa"
    ssh-keygen -R "$1" 2>/dev/null
    # -nNT flags will cause SSH to not allocate a tty and only do the port forwarding.
    ssh -nNT \
        -o "IdentitiesOnly=yes" \
        -o "UserKnownHostsFile=/dev/null" \
        -o "StrictHostKeyChecking=no" \
        -i "${RSA_KEY_FILE}" \
        -L "${HOST_LOCAL_PORT}:127.0.0.1:${REMOTE_LOCAL_PORT}" "ubuntu@${1}"
}

function bless_scp() {
    bless_me
    RSA_KEY_FILE="$HOME/.ssh/bless_rsa"
    ssh-keygen -R "$1"
    scp -o "IdentitiesOnly=yes" \
        -o "UserKnownHostsFile=/dev/null" \
        -o "StrictHostKeyChecking=no" \
        -i "${RSA_KEY_FILE}" "$@"
}

function bless_sftp() {
    bless_me
    RSA_KEY_FILE="$HOME/.ssh/bless_rsa"
    ssh-keygen -R "$1"
    sftp -o "IdentitiesOnly=yes" \
        -o "UserKnownHostsFile=/dev/null" \
        -o "StrictHostKeyChecking=no" \
        -i "${RSA_KEY_FILE}" "$@"
}
