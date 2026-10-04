#!/bin/sh

printf '%s' "$1" | wl-copy

notify-send \
    --app-name="kitty" \
    --icon="kitty" \
    --urgency=low \
    --expire-time=1000 \
    "Kitty" \
    "Copied"
