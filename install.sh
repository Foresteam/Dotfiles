#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dry_run=false
user_only=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        --user-only) user_only=true ;;
        -h|--help)
            printf 'Usage: %s [--dry-run] [--user-only]\n' "$0"
            printf 'Link configs and the mute-light helper, then enable their services.\n'
            printf 'Existing files are replaced; Noctalia GUI overrides are preserved.\n'
            exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; exit 1 ;;
    esac
done

if (( EUID == 0 )); then
    printf 'Run this as your normal user; sudo is used only for keyd.\n' >&2
    exit 1
fi

for command in niri noctalia python3 systemctl wpctl pactl busctl; do
    command -v "$command" >/dev/null || {
        printf 'Missing dependency: %s\n' "$command" >&2
        exit 1
    }
done
if ! "$user_only"; then
    command -v sudo >/dev/null
    command -v keyd >/dev/null
fi

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
noctalia_dir="${NOCTALIA_CONFIG_HOME:-$config_dir/noctalia}"
sources=(
    "$repo_dir/niri/config.kdl"
    "$repo_dir/noctalia/settings.toml"
    "$repo_dir/mimeapps.list"
    "$repo_dir/scripts/sync-mute-led.py"
    "$repo_dir/systemd/user/mute-led.service"
)
targets=(
    "$config_dir/niri/config.kdl"
    "$noctalia_dir/rice.toml"
    "$config_dir/mimeapps.list"
    "$HOME/.local/bin/rice-sync-mute-led"
    "$config_dir/systemd/user/mute-led.service"
)

# Validate all sources and destinations before replacing anything.
for i in "${!sources[@]}"; do
    [[ -f "${sources[i]}" ]] || { printf 'Missing source: %s\n' "${sources[i]}" >&2; exit 1; }
    if [[ -d "${targets[i]}" && ! -L "${targets[i]}" ]]; then
        printf 'Cannot replace directory: %s\n' "${targets[i]}" >&2
        exit 1
    fi
done
niri validate -c "$repo_dir/niri/config.kdl"
noctalia config validate "$repo_dir/noctalia/settings.toml"
if ! "$user_only"; then keyd check "$repo_dir/keyd/default.conf"; fi

if ! "$user_only"; then
    if "$dry_run"; then
        printf 'System link: /etc/keyd/default.conf -> %s/keyd/default.conf\n' "$repo_dir"
    else
        sudo bash "$repo_dir/scripts/install-keyd.sh"
    fi
fi

for i in "${!sources[@]}"; do
    printf 'Link: %s -> %s\n' "${targets[i]}" "${sources[i]}"
    if ! "$dry_run"; then
        mkdir -p -- "$(dirname -- "${targets[i]}")"
        ln -sfnT -- "${sources[i]}" "${targets[i]}"
    fi
done

if "$dry_run"; then
    printf 'Would reload Noctalia and enable/restart mute-led.service.\n'
    exit 0
fi
systemctl --user daemon-reload
systemctl --user enable mute-led.service
systemctl --user restart mute-led.service
if ! noctalia msg config-reload; then
    printf 'Noctalia is not running; the config will load on its next start.\n' >&2
fi
printf 'Installed. Keep this repository in place: the symlinks point here.\n'
