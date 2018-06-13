#!/bin/bash

function cookie_local() {
  pbpaste | jq '(.[] | .domain) |= "localhost"' | jq '(.[] | .expirationDate ) |= 2147483647' | pbcopy
}

function cookie_c20n() {
  pbpaste | jq '(.[] | .domain) |= "apps.test.jstor.org"' | jq '(.[] | .expirationDate ) |= 2147483647' | pbcopy
}

function json_clean() {
  pbpaste | jq . | pbcopy
}

function json_clean_sorted() {
  pbpaste | jq --sort-keys . | pbcopy
}

function flippy() {
  curl -H "Content-Type: application/json" -X POST -d '{"bit": true}' http://localhost:8181/watchable/dipswitch/mylists_write_ucm_client
  curl -H "Content-Type: application/json" -X POST -d '{"bit": true}' http://localhost:8181/watchable/dipswitch/mylists_read_ucm_client
  curl -H "Content-Type: application/json" -X POST -d '{"bit": false}' http://localhost:8181/watchable/dipswitch/mylists_write_rds_dao
}

function dbit() {
  curl -H "Content-Type: application/json" -X PUT -d '{"value": "bolt-rds01.test.cirrostratus.org"}' http://localhost:8181/watchable/persistentvariable/MyListsDbHost
}

function safe_curl() {
    # call this with a url argument, e.g.
    # safecurl.sh "http://eureka.test.cirrostratus.org:8080/eureka/v2/apps/"
    # separating the (verbose) curl options into an array for readability
    hash curl 2>/dev/null || { echo >&2 "I require curl but it's not installed.  Aborting."; return 1; }
    hash jq 2>/dev/null || { echo >&2 "I require jq but it's not installed.  Aborting."; return 1; }
    hash sed 2>/dev/null || { echo >&2 "I require sed but it's not installed.  Aborting."; return 1; }

    curl_args=(
      -H 'Accept:application/json'
      -H 'Content-Type:application/json'
      --write '\n%{http_code}\n'
      --fail
      --silent
    )
    #echo "${curl_args[@]}"
    # prepend some headers, but pass on whatever arguments this script was called with
    output=$(curl "${curl_args[@]}" "$@")
    return_code=$?
    if [ 0 -eq $return_code ]; then
        # remove the "http_code" line from the end of the output, and parse it
        echo "$output" | sed '$d' | jq .
    else
        # echo to stderr so further piping to jq will process empty output
        >&2 echo "Failure: code=$output"
    fi
}

function wti() {
    # What The Issue: Find the Jira issue from the topic
    JIRA_URL="https://jira.jstor.org"
    JIRA_API_URI="/rest/api/2/"
    # e.g. https://jira.jstor.org/rest/api/2/issue/CORE-5339
    RESULT=$(safe_curl -u "$JIRA_LOGIN:$JIRA_PASSWORD" -X GET "${JIRA_URL}${JIRA_API_URI}issue/${1}" | jq '{"key": .key, "summary": .fields.summary, "description": .fields.description}')
    KEY=$(echo $RESULT | jq -r '.key')
    SUMMARY=$(echo $RESULT | jq -r '.summary')
    DESCRIPTION=$(echo $RESULT | jq -r '.description')
    echo "$KEY - $SUMMARY"
    echo ""
    echo "Resolves [$KEY](https://jira.jstor.org/browse/$KEY)"
    echo ""
    echo "###### Description"
    echo "$DESCRIPTION"
    echo ""
    echo "###### Notify these people"
    echo "@ithaka/cypress"
}

function jira_pull() {
    # Formats a nice pull request message from a JIRA ticket
    # NOTE: requires jq
    # brew install jq
    # NOTE: Does not currently use j2m to convert jira markdown to github
    # npm install -g j2m
    hash curl 2>/dev/null || { echo >&2 "I require curl but it's not installed. Run 'brew install curl' and try again.  Aborting."; return 1; }
    hash jq 2>/dev/null || { echo >&2 "I require jq but it's not installed. Run 'brew install jq' and try again. Aborting."; return 1; }

    JIRA_URL="https://jira.jstor.org"
    JIRA_API_URI="/rest/api/2/"
    # getting login fo JIRA
    if [[ -z $JIRA_LOGIN ]]; then
    	read -p "Enter your login for JIRA: " JIRA_LOGIN
    fi
    # getting password fo JIRA
    if [[ -z $JIRA_PASSWORD ]]; then
    	read -p "Enter your login for JIRA: " JIRA_PASSWORD
    fi

    curl_args=(
      -u "$JIRA_LOGIN:$JIRA_PASSWORD"
      -X GET
      --write '\n%{http_code}\n'
      --fail
      --silent
      "${JIRA_URL}${JIRA_API_URI}issue/${1}"
    )
    #echo "${curl_args[@]}"
    # prepend some headers, but pass on whatever arguments this script was called with
    output=$(curl "${curl_args[@]}" "$@")

    # Warning: Curl is weird about escaping special characters in passwords
    RESULT=$(safe_curl "${curl_args[@]}" | jq '{"key": .key, "summary": .fields.summary, "description": .fields.description}')
    # Preserve whitespace
    IFS='🍔'
    KEY=$(echo "${RESULT}" | jq -r '.key')
    SUMMARY=$(echo "${RESULT}" | jq -r '.summary')
    # JIRA numbered lists converted to Github numbered lists with sed
    JIRA_DESCRIPTION=$(echo "${RESULT}" | jq -r '.description' | sed -E 's/^([\t| ]*)(# )([-\w]*)?/\11. \3/p')
    if hash j2m 2>/dev/null; then
        GITHUB_DESCRIPTION=$(echo "${JIRA_DESCRIPTION}" | j2m --toM --stdin)
    else
        GITHUB_DESCRIPTION="${JIRA_DESCRIPTION}"
    fi
    echo "${KEY}: ${SUMMARY}"
    echo ""
    echo "Resolves [${KEY}](https://jira.jstor.org/browse/${KEY})"
    echo ""
    echo "###### Description"
    echo "${GITHUB_DESCRIPTION}"
    echo ""
    echo "###### Notify these people"
    echo "@ithaka/cypress"
    unset IFS
}

function make_pull() {
    # NOTE: Your topic branch must match jira issue e.g. CORE-5339
    # Opens a pull request on GitHub for the project that the "origin"
    # The description will be lifted from JIRA
    # This command will abort operation if it detects that
    # the current topic branch has local commits that are not yet pushed
    #  to its upstream  branch on the remote.
    # ALSO NOTE: requires hub. Install it with:
    # brew install hub curl jq
    hash git 2>/dev/null || { echo >&2 "I require git but it's not installed. Run 'brew install git' and try again. Aborting."; return 1; }
    hash hub 2>/dev/null || { echo >&2 "I require hub but it's not installed. Run 'brew install hub' and try again. Aborting."; return 1; }

    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    # Preserve whitespace by setting IFS to something unlikely
    IFS='🍔'
    MESSAGE="$(jira_pull "${CURRENT_BRANCH}")"
    # If when you execute the next line (hub) you get the error:
    # Unprocessable Entity (HTTP 422) Invalid value for "head"
    # Then you forgot to push. Yeah. Non-obvious
    hub pull-request -o -m "${MESSAGE}"
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo "You forgot to push if you got Unprocessable Entity (HTTP 422)"
    unset IFS
}
