#!/bin/bash
# call this with a url argument, e.g.
# safecurl.sh "http://eureka.test.cirrostratus.org:8080/eureka/v2/apps/"
# separating the (verbose) curl options into an array for readability
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
