#!/bin/sh

printf '%s' "$1" \
  | tr '\r\n\t' '   ' \
  | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//' \
  | wl-copy
