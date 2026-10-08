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
            printf 'Link configs and helpers, then enable their services.\n'
            printf 'Existing files are replaced; Noctalia GUI overrides are preserved.\n'
            exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; exit 1 ;;
    esac
done

if (( EUID == 0 )); then
    printf 'Run this as your normal user; sudo is used only for keyd.\n' >&2
    exit 1
fi

for command in niri noctalia kitty wl-copy notify-send jq python3 systemctl systemd-inhibit wpctl pactl busctl git; do
    command -v "$command" >/dev/null || {
        printf 'Missing dependency: %s\n' "$command" >&2
        exit 1
    }
done
if ! "$user_only"; then
    command -v sudo >/dev/null
    command -v keyd >/dev/null
    [[ -f "$repo_dir/systemd/system/systemd-suspend.service.d/lockscreen-delay.conf" ]] || {
        printf 'Missing suspend delay config.\n' >&2
        exit 1
    }
fi

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
noctalia_dir="${NOCTALIA_CONFIG_HOME:-$config_dir/noctalia}"
niri_conf_source="$repo_dir/niri/conf.d"
niri_conf_target="$config_dir/niri/conf.d"
kvantum_theme="$repo_dir/kvantum/Kvantum-Tokyo-Night/Kvantum-Tokyo-Night"
if [[ ! -f "$kvantum_theme/Kvantum-Tokyo-Night.kvconfig" || ! -f "$kvantum_theme/Kvantum-Tokyo-Night.svg" ]]; then
    if "$dry_run"; then
        printf 'Would initialize Kvantum-Tokyo-Night submodule.\n'
    else
        git -C "$repo_dir" submodule update --init --recursive -- kvantum/Kvantum-Tokyo-Night
    fi
fi
sources=(
    "$repo_dir/niri/config.kdl"
    "$repo_dir/niri/scripts/close-hovered-window.sh"
    "$repo_dir/noctalia/settings.toml"
    "$repo_dir/environment.d/qt.conf"
    "$repo_dir/pipewire/pipewire.conf.d/99-hifi.conf"
    "$repo_dir/pipewire/pipewire-pulse.conf.d/pipewire.conf"
    "$repo_dir/kitty/kitty.conf"
    "$repo_dir/kitty/copy.sh"
    "$repo_dir/kitty/clean-copy.sh"
    "$repo_dir/kvantum/kvantum.kvconfig"
    "$repo_dir/mimeapps.list"
    "$repo_dir/scripts/sync-mute-led.py"
    "$repo_dir/scripts/inhibit-on-download"
    "$repo_dir/scripts/patch-vscodium-theme.py"
    "$repo_dir/noctalia/templates/vscodium-alpha.json"
    "$repo_dir/systemd/user/mute-led.service"
    "$repo_dir/systemd/user/inhibit-on-download.service"
    "$repo_dir/systemd/user/plasma-xdg-desktop-portal-kde.service.d/override.conf"
)
targets=(
    "$config_dir/niri/config.kdl"
    "$config_dir/niri/scripts/close-hovered-window.sh"
    "$noctalia_dir/rice.toml"
    "$config_dir/environment.d/qt.conf"
    "$config_dir/pipewire/pipewire.conf.d/99-hifi.conf"
    "$config_dir/pipewire/pipewire-pulse.conf.d/pipewire.conf"
    "$config_dir/kitty/kitty.conf"
    "$config_dir/kitty/copy.sh"
    "$config_dir/kitty/clean-copy.sh"
    "$config_dir/Kvantum/kvantum.kvconfig"
    "$config_dir/mimeapps.list"
    "$HOME/.local/bin/rice-sync-mute-led"
    "$HOME/.local/bin/inhibit-on-download"
    "$HOME/.local/bin/rice-patch-vscodium-theme"
    "$noctalia_dir/templates/vscodium-alpha.json"
    "$config_dir/systemd/user/mute-led.service"
    "$config_dir/systemd/user/inhibit-on-download.service"
    "$config_dir/systemd/user/plasma-xdg-desktop-portal-kde.service.d/override.conf"
)

# Validate all sources and destinations before replacing anything.
for i in "${!sources[@]}"; do
    [[ -f "${sources[i]}" ]] || { printf 'Missing source: %s\n' "${sources[i]}" >&2; exit 1; }
    if [[ -d "${targets[i]}" && ! -L "${targets[i]}" ]]; then
        printf 'Cannot replace directory: %s\n' "${targets[i]}" >&2
        exit 1
    fi
done
[[ -d "$niri_conf_source" ]] || { printf 'Missing source: %s\n' "$niri_conf_source" >&2; exit 1; }
if [[ -e "$niri_conf_target" && ! -L "$niri_conf_target" ]]; then
    printf 'Cannot replace directory: %s\n' "$niri_conf_target" >&2
    exit 1
fi
kvantum_target="$config_dir/Kvantum/Kvantum-Tokyo-Night"
if [[ ! -f "$kvantum_theme/Kvantum-Tokyo-Night.kvconfig" || ! -f "$kvantum_theme/Kvantum-Tokyo-Night.svg" ]] && ! "$dry_run"; then
    printf 'Kvantum submodule is incomplete: %s\n' "$kvantum_theme" >&2
    exit 1
fi
# When already linked, validate through the installed path so relative includes
# (such as Noctalia's generated niri/noctalia.kdl) resolve beside config.kdl.
niri_config="$repo_dir/niri/config.kdl"
if [[ -L "$config_dir/niri/config.kdl" && "$(readlink -f -- "$config_dir/niri/config.kdl")" == "$niri_config" ]]; then
    niri_config="$config_dir/niri/config.kdl"
fi
niri validate -c "$niri_config"
noctalia config validate "$repo_dir/noctalia/settings.toml"
if ! "$user_only"; then keyd check "$repo_dir/keyd/default.conf"; fi

if ! "$user_only"; then
    if "$dry_run"; then
        printf 'System link: /etc/keyd/default.conf -> %s/keyd/default.conf\n' "$repo_dir"
        printf 'System link: /etc/systemd/system/systemd-suspend.service.d/lockscreen-delay.conf -> %s/systemd/system/systemd-suspend.service.d/lockscreen-delay.conf\n' "$repo_dir"
    else
        sudo bash "$repo_dir/scripts/install-keyd.sh"
        sudo bash "$repo_dir/scripts/install-suspend-delay.sh"
    fi
fi

printf 'Link: %s -> %s\n' "$niri_conf_target" "$niri_conf_source"
if ! "$dry_run"; then
    mkdir -p -- "$(dirname -- "$niri_conf_target")"
    ln -sfnT -- "$niri_conf_source" "$niri_conf_target"
fi

for i in "${!sources[@]}"; do
    printf 'Link: %s -> %s\n' "${targets[i]}" "${sources[i]}"
    if ! "$dry_run"; then
        mkdir -p -- "$(dirname -- "${targets[i]}")"
        ln -sfnT -- "${sources[i]}" "${targets[i]}"
    fi
done

if [[ -e "$kvantum_target" && ! -L "$kvantum_target" ]]; then
    backup="$config_dir/Kvantum/.Kvantum-Tokyo-Night.rice-backup"
    if [[ -e "$backup" ]]; then
        backup="$backup.$(date +%Y%m%d%H%M%S)"
    fi
    printf 'Backup: %s -> %s\n' "$kvantum_target" "$backup"
    if ! "$dry_run"; then
        mv -- "$kvantum_target" "$backup"
    fi
fi
printf 'Link: %s -> %s\n' "$kvantum_target" "$kvantum_theme"
if ! "$dry_run"; then
    mkdir -p -- "$(dirname -- "$kvantum_target")"
    ln -sfnT -- "$kvantum_theme" "$kvantum_target"
fi

if "$dry_run"; then
    printf 'Would reload Noctalia, enable/restart mute-led.service and inhibit-on-download.service, and restart the KDE portal.\n'
    exit 0
fi
systemctl --user daemon-reload
systemctl --user enable mute-led.service
systemctl --user restart mute-led.service
systemctl --user enable inhibit-on-download.service
systemctl --user restart inhibit-on-download.service
systemctl --user restart plasma-xdg-desktop-portal-kde.service
systemctl --user restart xdg-desktop-portal.service
if ! noctalia msg config-reload; then
    printf 'Noctalia is not running; the config will load on its next start.\n' >&2
fi
printf 'Installed. Keep this repository in place: the symlinks point here.\n'
