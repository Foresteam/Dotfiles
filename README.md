# Desktop configuration

This repository tracks the installed desktop configuration. Change and validate
the tracked files before applying them; use Git history for rollback.

Run `./install.sh --dry-run` to preview, then `./install.sh` to install. The
installer replaces the files below with symlinks into this checkout, installs
the F1 mute-light helper as `~/.local/bin/rice-sync-mute-led`, and enables keyd
and the mute-light user service. Use `--user-only` to skip system keyd changes.
Run it as your normal user; it uses sudo for keyd. Keep the checkout in place.

Required commands: `niri`, `noctalia`, `keyd`, `python3`, `wpctl`, `pactl`,
`busctl`, `systemctl`, and `sudo`. Existing applications, wallpapers, fonts,
and cursor assets must already be installed.

| Tracked file | Installed location |
| --- | --- |
| `niri/config.kdl` | `~/.config/niri/config.kdl` |
| `noctalia/settings.toml` | `~/.config/noctalia/rice.toml` |
| `mimeapps.list` | `~/.config/mimeapps.list` |
| `keyd/default.conf` | `/etc/keyd/default.conf` |
| `systemd/user/mute-led.service` | `~/.config/systemd/user/mute-led.service` |

Noctalia rewrites `~/.local/state/noctalia/settings.toml` when settings change
through the UI, so the installer links the declarative config instead. Installing
clears those GUI overrides so the tracked settings take effect. Save any wanted
GUI changes in Git before reinstalling.

Keyd sends F24 when Win is tapped and keeps Win as a modifier when held. Niri maps
F24 to its overview. Fn brightness, volume, and media shortcuts use Noctalia.
The user service updates the F1 light from the default output's mute state,
including USB audio devices, through logind.
