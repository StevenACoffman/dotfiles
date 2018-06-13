#!/bin/bash

usage() {
	echo "
Usage: wti [-h?] [-l LOGIN] ISSUE...
wti = \"(W)hat (T)he (I)ssue?\". Script tries to get description of the specified
ISSUE(es) from jira. For each ISSUE in list script will ouput the line in
the following format: ISSUE_ID — ISSUE_DESC
options:
 -h -?	Print this message and exit
 -l	LOGIN	Jira-user login. Will be promted if not specified."
}

shortusage() {
	echo "
Usage: wti [-h?] [-l LOGIN] ISSUE...
See wti -h for help"
}

error() {
	if [[ -n $1 ]];
	then
		echo -e "\nERROR: $1"
		if [[ -n $2 ]];
		then
			shortusage
		fi
		exit 1
	fi
}

JIRA_URL="https://jira.jstor.org"
JIRA_AUTH_URI="/rest/auth/2/session"
JIRA_API_URI="/rest/api/2/"

OPTIND=1

# Parsing flags
while getopts "h?l:" opt
do
	case $opt in
		h|\?)
			usage
			exit 0
			;;
		l)
			JIRA_LOGIN=$OPTARG
			;;
	esac
done

# getting list of braches
if [[ -z ${!OPTIND} ]]; then
	error "You must specified at least one issue!" 1
else
	for ((ARG=$OPTIND, NUM=0; ARG>0; ARG++));
	do
		if [[ -z ${!ARG} ]];
		then
			break
		fi
		ISSUES[$NUM]=${!ARG}
		NUM=$[NUM+1]
	done
fi

# getting login fo JIRA
if [[ -z $JIRA_LOGIN ]]; then
	read -p "Enter your login for JIRA: " JIRA_LOGIN
fi

# getting password for JIRA
if [[ -z $JIRA_PASSWORD ]]; then
read -sp "Enter your password for JIRA: " JIRA_PASSWORD
fi
echo ""

# authentication in JIRA
#JIRA_SESSION_ID=`curl -s -H "Content-Type: application/json" -d "{\"username\":\"${JIRA_LOGIN}\",\"password\":\"${JIRA_PASSWORD}\"}" -X POST ${JIRA_URL}${JIRA_AUTH_URI} | gsed -r 's/^.+JSESSIONID","value":"([^"]+).+$/\1/ig'`
#
#if [[ -n $(echo $JIRA_SESSION_ID | grep error) ]]
#then
#	error "Wrong login or password!"
#fi
#curl -D - -u $JIRA_LOGIN:$JIRA_PASSWORD -X GET -H "Content-Type: application/json" https://jira.jstor.org/rest/api/2/issue/CORE-5339
# getting info about branches
for ((I=0; I<${#ISSUES[@]}; I++));
do
	SED=`curl -s -H "Content-Type: application/json" -u $JIRA_LOGIN:$JIRA_PASSWORD ${JIRA_URL}${JIRA_API_URI}issue/${ISSUES[$I]}?fields=summary | gsed -n -re 's@\\\["]([^\\\]+)\\\["]@«\1»@ig' -e 's/^.+key":"([^"]+)".+summary":"([^"]+).+$/\1 - \2\n/igp'`
	if [[ -z $SED ]]
	then
		echo "Issue \"${ISSUES[$I]}\" not found or unknown error has occured!"
	else
		echo $SED
	fi
done
