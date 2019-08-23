#!/bin/bash
# Other webhook

# kubernetes alerts webhook
# https://hooks.slack.com/services/something/something/something
function post_message() {
    if [[ $# -eq 0 ]]; then
        echo "usage: $0 message"
        exit 1
    fi
    WEBHOOK_URL='https://hooks.slack.com/services/'"$SLACK_API_TOKEN_PROMETHEUS"
    CHANNEL='#steveroom'
    USERNAME='scoffbot'
    ICON_URL=
    ICON_EMOJI=':chart_with_upwards_trend:'
    # To add emoji, add this to the json below:
    # "icon_emoji": ":chart_with_upwards_trend:"

PAYLOAD=$(cat << EOT
{
  "username": "${USERNAME}",
  "text": "${AT_USER} ${1}",
  "channel": "${CHANNEL}",
  "icon_url": "${ICON_URL}",
  "as_user": false
}
EOT
)

    curl -i -H 'Accept: application/json' -H 'Content-Type: application/json' -X POST -d "${PAYLOAD}" "${WEBHOOK_URL}"

}

function slack_arrow() {

    while true ; do
      for i in arrow_up arrow_upper_right arrow_right arrow_lower_right arrow_down arrow_lower_left arrow_left arrow_upper_left ; do
        TEXT="This%20way"
        EMOJI="$i"
        echo "$TEXT: $EMOJI"
        curl --silent -X GET "https://slack.com/api/users.profile.set?token=${SLACK_TOKEN}&profile=%7B%20%22status_text%22%3A%20%22${TEXT}%22%2C%20%22status_emoji%22%3A%20%22%3A${EMOJI}%3A%22%20%7D&pretty=1" >/dev/null
        sleep 1
      done
    done
}

function slack_clock() {

# Fill in your slack token (the bad way), and then this will
# set your status text/emoticon to the current hour of the day!
#
# After testing, put this in your contrab like:
# 0 * * * * /path/to/slack-clock.sh >/dev/null 2>&1

HOUR=$(date '+%I' | perl -pe 's/^0//')
TEXT="${HOUR}%20o%27clock"
EMOJI="clock${HOUR}"
#Don't watch the clock; do what it does. Keep going.
echo "${TEXT}: ${EMOJI}"
curl -s "https://slack.com/api/users.profile.set?token=${SLACK_TOKEN}&profile=%7B%20%22status_text%22%3A%20%22${TEXT}%22%2C%20%22status_emoji%22%3A%20%22%3A${EMOJI}%3A%22%20%7D&pretty=1" >/dev/null

}
