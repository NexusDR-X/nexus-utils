#!/usr/bin/env bash

# Amateur radio operator name lookup given call sign.
#
# This script requires one argument, an amateur radio
# call sign. It sends a REST query to 73s.com for that
# call sign and returns the associated name. 
#
# The call sign can have trailing numbers or a hyphen
# (those are stripped off), and is case insensitive.
# The script returns:
#     *  A non-zero code if no argument is 
#        supplied or if the curl command containing the 
#        REST query fails.
#     *  A zero code and an empty string if the query
#        was OK but the call sign was not found
#     *  A zero code and a string containing the name
#        if the query was OK and found the call sign. 

REST_HOST="73s.com"

# Strip trailing hyphens/numbers from the callsign
CALL="$(echo $1 | sed -e 's/[0-9-]*$//')"
# Exit with code 1 if no argument (callsign) supplied
[[ -z $CALL ]] && exit 1

# Send REST query for $CALL to $REST_HOST and extract the 
# XML 'name' value
curl --connect-timeout 2 -sX GET http://${REST_HOST}/${CALL}.json 2>/dev/null | jq -r .name
# Exit with curl's exit code
exit ${PIPESTATUS[0]}


