#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if (( EUID != 0 )); then
    printf 'Run this script with sudo.\n' >&2
    exit 1
fi

target_dir=/etc/systemd/system/systemd-suspend.service.d
install -d -- "$target_dir"
ln -sfnT -- "$repo_dir/systemd/system/systemd-suspend.service.d/lockscreen-delay.conf" \
    "$target_dir/lockscreen-delay.conf"
systemctl daemon-reload
