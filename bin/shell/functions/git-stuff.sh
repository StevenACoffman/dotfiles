#!/bin/bash
function gb () {
    git rev-parse --abbrev-ref HEAD
}

function gc () {
    # Usage: gc Message
    # result:
        CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        git commit -m "${CURRENT_BRANCH}: $*"
}

function commit() {
    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    # I am in the habit of typing commit -am "Message"
    # This next bit removes the "-am" if it was supplied
    MESSAGE="${1}"
    if [ "$#" -gt "1" ]
    then
        MESSAGE="${2}"
    fi

    git commit -asm "${CURRENT_BRANCH}: ${MESSAGE}"
}

function test-safe-push() {
  #branch=$(git symbolic-ref --short -q HEAD)
  #branch=$(git status --short --branch|head -1|sed -n -e 's/\.\.\..*$//' -e 's/[# ]*//gp')
  branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  repo_name="$(basename "$(git rev-parse --show-toplevel)")"
  if [ "$branch" == "master" ]; then
    echo "Whoa you are on master!"
  else
    git push "git@git.test.cirrostratus.org:repos/${repo_name}.git" "${branch}:master" -f
  fi

}

function prod-safe-push() {
  #branch=$(git symbolic-ref --short -q HEAD)
  #branch=$(git status --short --branch|head -1|sed -n -e 's/\.\.\..*$//' -e 's/[# ]*//gp')
  branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  repo_name="$(basename "$(git rev-parse --show-toplevel)")"
  if [ "$branch" == "master" ]; then
    echo "Whoa you are on master!"
  else
    git push "git@git.prod.cirrostratus.org:repos/${repo_name}.git" "${branch}:master"
  fi

}

#I cannot seem to remember underscores vs dashes
function safe-push() {
    safe_push "$@"
}

function safe_push() {
  #branch=$(git symbolic-ref --short -q HEAD)
  #branch=$(git status --short --branch|head -1|sed -n -e 's/\.\.\..*$//' -e 's/[# ]*//gp')
  branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  if [ "$branch" == "master" ]; then
    echo "Whoa you are on master!"
  else
    git push origin "${branch}"
  fi
}

#https://github.com/ithaka/jstor/search?q=8ebc22b9686db1d78c22881fb9e81614ffef1b13&ref=cmdform&type=Issues
#Note: This does not remotely work right now. I dunno.
function pr_for_sha {
  #What is this for again???
  GITHUB_UPSTREAM=ithaka
  REPO=jstor
  git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${REPO}/pull/%
}

#git push git@git.test.cirrostratus.org:repos/mylists-service.git COMM-239:master -f

function getnow {
  NOW=$(date +%Y%m%dT%H%M); echo "search_$NOW"; ./deploy.sh --version "search_$NOW"
}
