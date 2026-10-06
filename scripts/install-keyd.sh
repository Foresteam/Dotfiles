#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if (( EUID != 0 )); then
    printf 'Run this script with sudo.\n' >&2
    exit 1
fi
keyd check "$repo_dir/keyd/default.conf"
install -d /etc/keyd
ln -sfnT -- "$repo_dir/keyd/default.conf" /etc/keyd/default.conf
systemctl enable keyd.service
systemctl restart keyd.service
