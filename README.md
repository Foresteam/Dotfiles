# Desktop configuration

This repository tracks the installed desktop configuration. Change and validate
the tracked files before applying them; use Git history for rollback.

Run `./install.sh --dry-run` to preview, then `./install.sh` to install. The
installer replaces the files below with symlinks into this checkout, installs
the F1 mute-light helper as `~/.local/bin/rice-sync-mute-led`, and enables keyd
and the mute-light user service. Use `--user-only` to skip system changes.
Run it as your normal user; it uses sudo for keyd and the suspend delay. Keep the checkout in place.

Required commands: `niri`, `noctalia`, `keyd`, `kitty`, `wl-copy`, `notify-send`,
`jq`, `python3`, `wpctl`, `pactl`, `busctl`, `systemctl`, `git`, and `sudo`. Existing applications,
wallpapers, fonts, and cursor assets must already be installed.

| Tracked file | Installed location |
| --- | --- |
| `niri/config.kdl` | `~/.config/niri/config.kdl` |
| `niri/scripts/close-hovered-window.sh` | `~/.config/niri/scripts/close-hovered-window.sh` |
| `noctalia/settings.toml` | `~/.config/noctalia/rice.toml` |
| `environment.d/qt.conf` | `~/.config/environment.d/qt.conf` |
| `pipewire/pipewire.conf.d/99-hifi.conf` | `~/.config/pipewire/pipewire.conf.d/99-hifi.conf` |
| `pipewire/pipewire-pulse.conf.d/pipewire.conf` | `~/.config/pipewire/pipewire-pulse.conf.d/pipewire.conf` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `kitty/copy.sh` | `~/.config/kitty/copy.sh` |
| `kitty/clean-copy.sh` | `~/.config/kitty/clean-copy.sh` |
| `kvantum/kvantum.kvconfig` | `~/.config/Kvantum/kvantum.kvconfig` |
| `kvantum/Kvantum-Tokyo-Night` submodule's theme directory | `~/.config/Kvantum/Kvantum-Tokyo-Night` |
| `noctalia/templates/vscodium-alpha.json` | `~/.config/noctalia/templates/vscodium-alpha.json` |
| `scripts/patch-vscodium-theme.py` | `~/.local/bin/rice-patch-vscodium-theme` |
| `mimeapps.list` | `~/.config/mimeapps.list` |
| `keyd/default.conf` | `/etc/keyd/default.conf` |
| `systemd/user/mute-led.service` | `~/.config/systemd/user/mute-led.service` |
| `systemd/system/systemd-suspend.service.d/lockscreen-delay.conf` | `/etc/systemd/system/systemd-suspend.service.d/lockscreen-delay.conf` |
| `systemd/user/plasma-xdg-desktop-portal-kde.service.d/override.conf` | `~/.config/systemd/user/plasma-xdg-desktop-portal-kde.service.d/override.conf` |

Noctalia rewrites `~/.local/state/noctalia/settings.toml` when settings change
through the UI, so the installer links the declarative config instead. Existing
GUI overrides are preserved and take precedence over the tracked settings.

The installer initializes the HTTPS Kvantum submodule when needed, then links
the theme directory and selection config. It backs up an existing theme directory
as `~/.config/Kvantum/.Kvantum-Tokyo-Night.rice-backup` before linking it.

Matching Discord theme:
[DiscordTokyoNightTransparent](https://github.com/Foresteam/DiscordTokyoNightTransparent).

Kitty reads colors from `~/.config/kitty/themes/noctalia.conf`, which Noctalia
generates. The installer links Kitty's main config and copy helpers while
leaving the generated color file in place.

The VSCodium opacity template runs after the community VSCode template. Its
synchronous post-hook patches every installed `noctalia.noctaliatheme-*` variant,
preserving generated RGB colors and capping all background tokens at `A6` alpha.
`_terminalAnsiAlpha` separately caps the 16 terminal ANSI palette colors at
`A6`. Change that one value to tune colored terminal cells; the same palette
also colors ANSI foreground text. The base `terminal.background` remains fully
transparent. VSCodium's GPU-accelerated terminal renderer draws colored cells
opaque despite their alpha values, so disable it in
`~/.config/VSCodium/User/settings.json` with
`"terminal.integrated.gpuAcceleration": "off"` for these colors to work.
Already translucent highlights stay at their lower opacity. Popup and context
menu surfaces use `FF` so they remain opaque without compositor blur. Explicit
entries use `80` for inactive title/tabs and `B3` for the active tab. Missing
tokens use the overlay's current palette color. Edit
`noctalia/templates/vscodium-alpha.json` to change opacity; keep the VSCode
community template enabled in Noctalia. Reapply with `noctalia msg templates-apply`.

`mimeapps.list` assigns both plain text and empty files to VSCodium:
`xdg-open` identifies an empty config as `inode/x-empty`, while GIO uses
`application/x-zerosize`. Without an empty-file association, `xdg-open` can fall
back to a browser. Apply the tracked associations with
`install -m 600 mimeapps.list ~/.config/mimeapps.list`.

Keyd sends F24 when Win is tapped and keeps Win as a modifier when held. Niri maps
F24 to its overview. Fn brightness, volume, and media shortcuts use Noctalia.
The user service updates the F1 light from the default output's mute state,
including USB audio devices, through logind.

The systemd suspend drop-in waits two seconds before freezing the user session,
giving Noctalia's lock animation time to finish. Install it separately with
`sudo bash scripts/install-suspend-delay.sh` if the rest of the setup is already linked.
