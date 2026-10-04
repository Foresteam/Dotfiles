#!/bin/sh

text=$(
    printf '%s' "$1" \
        | tr '\r\n\t' '   ' \
        | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
)

[ -n "$text" ] || exit 0

printf '%s' "$text" | wl-copy

notify-send \
    --app-name="kitty" \
    --icon="kitty" \
    --urgency=low \
    --expire-time=1000 \
    "Kitty" \
    "Copied (clean)"
