#!/usr/bin/env bash

# Sends a winlink message to keep account alive. This acript is intended
# to be run periodically via cron. Winlink accounts expire if no message
# is passed via RF or Winlink for 1 year. Script uses telnet transport.

# 1 argument is required: 
#   List of recipient email addresses, comma separated. 
#
# A 2nd optional argument can be provided: Full path to the pat configuration file.
# If the 2nd argument is not provided, the pat configuration 
#
# Other requirements:
#   - pat version 0.12.1 or later
#   - jq to extract callsign from JSON configuration file.

# Author: Steve Magnuson, AG7GN
# Version 1.0.0
# License: GPL v3.0

MAILTO="$(echo ${1} | xargs -d,)"
DEFAULT_CONFIG_PATH="$HOME/.config/pat/config.json"
PAT_CONFIG_PATH="${2:-$DEFAULT_CONFIG_PATH}"
[[ -n $MAILTO ]] || exit 1 
[[ -s $PAT_CONFIG_PATH ]] || exit 1
command -v pat &>/dev/null || exit 1
command -v jq &>/dev/null || exit 1

CALL="$(jq -r ".mycall" $PAT_CONFIG_PATH)"

SUBJECT="Periodic ${CALL^^} Winlink account keepalive"
MESSAGE="Keepalive message from ${CALL^^} Winlink account\nSent using pat client from host $HOSTNAME"
echo -e "$MESSAGE" | \
    $(command -v pat) --config "$PAT_CONFIG_PATH" \
    --event-log /dev/null compose \
    --subject "$SUBJECT" $MAILTO &>/dev/null
$(command -v pat) --config "$PAT_CONFIG_PATH" \
    --event-log /dev/null \
    --send-only connect telnet &>/dev/null

