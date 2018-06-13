#!/bin/bash

#
# Helper Functions
#
dcleanup(){
	local containers
	containers=( $(docker ps -aq 2>/dev/null) )
	docker rm "${containers[@]}" 2>/dev/null
	local volumes
	volumes=( $(docker ps --filter status=exited -q 2>/dev/null) )
	docker rm -v "${volumes[@]}" 2>/dev/null
	local images
	images=( $(docker images --filter dangling=true -q 2>/dev/null) )
	docker rmi "${images[@]}" 2>/dev/null
}
del_stopped(){
	local name=$1
	local state
	state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

	if [[ "$state" == "false" ]]; then
		docker rm "$name"
	fi
}

dstop() {
    local image_name=$1
    docker stop "$(docker ps --format '{{.ID}}' --filter "ancestor=${image_name}")"
}

dclean_deep() {
    docker system prune -a
}

function dc_trace_cmd() {
  local parent
  parent=$(docker inspect -f '{{ .Parent }}' $1) 2>/dev/null
  declare -i level=$2
  echo "${level}: $(docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null)"
  level=$((level+1))
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

function dsha() {
    # Get "D" sha - Get The Sha256 (Digest of an image)
    local repo=$1
    docker images --format '{{.Digest}}' "$(echo $repo | cut -d: -f2-)"
}

# aws s3 cp s3://sequoia-install/certs-and-keys/dockerregistrySSL/docker-registry.acorn.cirrostratus.org.crt ~/Documents
# sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/Documents/docker-registry.acorn.cirrostratus.org.crt


# open ~/Documents

# Double-click cert file. This will bring up the Keychain Access utility. Enter your password to unlock it.
#
# Be sure you add the certificate to the System keychain, not the login keychain. Click "Always Trust," even though this doesn't seem to do anything.
#
# After it has been added, double-click it. You may have to authenticate again.
#
# Expand the "Trust" section.
# "When using this certificate," set to "Always Trust"

function list_images () {
    #List all repositories (effectively images):
    curl --cacert ~/docker-registry.acorn.cirrostratus.org.crt -X GET https://docker-registry.acorn.cirrostratus.org/v2/_catalog
}

function list_tags () {
    # REPO e.g. "cypress/fluentd"
    REPO="$1"

    # List all tags for a repository:
    curl --cacert ~/docker-registry.acorn.cirrostratus.org.crt -X GET "https://docker-registry.acorn.cirrostratus.org/v2/${REPO}/tags/list"
    # e.g. > {"name":"ubuntu","tags":["14.04"]}
}

function run-instance () {
aws ec2 run-instances \
    --image-id ami-ID# \
    --count 1 \
    --instance-type t2.micro \
    --key-name MySSHKeyName \
    --security-groups sg-name
}
