#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
keyd check "$repo_dir/keyd/default.conf"
install -m 644 "$repo_dir/keyd/default.conf" /etc/keyd/default.conf
keyd reload
