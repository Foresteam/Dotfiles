#!/bin/sh

id="$(niri msg --json pick-window | jq -er '.id // empty')" || exit
[ -n "$id" ] && niri msg action close-window --id "$id"
