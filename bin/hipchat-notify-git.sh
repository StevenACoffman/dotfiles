#!/bin/bash
# Steve Room# 2580026
ROOM_ID=2580026
#Andela Room # 2692781
#ROOM_ID=2692781

branch_name="$(git symbolic-ref HEAD 2>/dev/null)" \
|| branch_name="(unnamed branch)"     # detached HEAD
branch_name=${branch_name##refs/heads/}
version="foo"
#MESSAGE="${branch_name} ${1}"
MESSAGE="$(cat "$HOME/hipchat_notification.json")"

MESSAGE="$(echo "$MESSAGE" | jq '.card += {"url": "https://console.aws.amazon.com/s3/home?region=us-east-1#&bucket=jstor-ui-assets&prefix='$version'", "id": "'$version'"}' | jq '.card.attributes += [{"label": "Version", "value": {"label": "'$version'", "style": "lozenge"}}]')"

curl -H "Content-type: application/json" \
-s \
-H "Authorization: Bearer $HIPCHAT_AUTH_TOKEN" \
-X POST \
-d "$MESSAGE" \
https://api.hipchat.com/v2/room/$ROOM_ID/notification
#-d "{\"color\": \"purple\", \"message_format\": \"html\", \"message\": \"$MESSAGE\"}" \
