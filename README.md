# Desktop configuration

This repository tracks the installed desktop configuration. Change and validate
the tracked files before applying them; use Git history for rollback.

| Tracked file | Installed location |
| --- | --- |
| `niri/config.kdl` | `~/.config/niri/config.kdl` |
| `noctalia/settings.toml` | `~/.local/state/noctalia/settings.toml` |
| `mimeapps.list` | `~/.config/mimeapps.list` |
| `keyd/default.conf` | `/etc/keyd/default.conf` |
| `systemd/user/mute-led.service` | `~/.config/systemd/user/mute-led.service` |

Noctalia rewrites its state file when settings change through the UI. Import those
changes into the tracked file before editing it here.

Keyd sends F24 when Win is tapped and keeps Win as a modifier when held. Niri maps
F24 to its overview. Fn brightness, volume, and media shortcuts use Noctalia.
The user service updates the F1 light from the default output's mute state,
including USB audio devices, through logind.
