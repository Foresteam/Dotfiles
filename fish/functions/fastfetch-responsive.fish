function fastfetch-responsive
    set -l cfgroot "$HOME/.config"
    set -q XDG_CONFIG_HOME; and set cfgroot "$XDG_CONFIG_HOME"

    set -l preset
    for p in "$cfgroot/fastfetch/presets/examples/18.jsonc" \
        /usr/share/fastfetch/presets/examples/18.jsonc \
        /usr/local/share/fastfetch/presets/examples/18.jsonc
        if test -f "$p"
            set preset "$p"
            break
        end
    end

    if not set -q preset[1]
        echo "Cannot find Fastfetch preset 18." >&2
        return 1
    end

    set -l cols 80
    set -q COLUMNS; and set cols "$COLUMNS"

    if test "$cols" -lt 70
        command /usr/bin/fastfetch --logo-type none \
            --structure OS:Kernel:Uptime:Shell:Terminal:CPU:GPU:Memory:Disk
        return
    end

    set -l image_args --logo-type none
    set -l logo_width 0
    set -l padding 0

    if set -q KITTY_WINDOW_ID; and set -q FASTFETCH_IMAGE; and test -f "$FASTFETCH_IMAGE"
        # Reserve approximate space for this portrait.
        # Only height is passed to Fastfetch; width scales proportionally.
        set logo_width 18
        set padding 2
        set image_args --logo-type kitty \
            --logo "$FASTFETCH_IMAGE" \
            --logo-height 12 \
            --logo-padding-left 0 \
            --logo-padding-right "$padding"
    end

    set -l width (math "$cols - $logo_width - $padding - 3")
    set -l tmp (mktemp --suffix=.jsonc)
    or return 1

    python3 -c '
import pathlib
import sys

source, target, width = sys.argv[1], sys.argv[2], int(sys.argv[3])
text = pathlib.Path(source).read_text()
text = text.replace("═" * 75, "═" * width)
text = text.replace(r"\u001b[75C", rf"\u001b[{width}C")
text = text.replace(r"\u001b[75D", rf"\u001b[{width}D")
text = text.replace(r"\u001b[76D", rf"\u001b[{width + 1}D")
pathlib.Path(target).write_text(text)
' "$preset" "$tmp" "$width"

    if test $status -ne 0
        rm -f "$tmp"
        return 1
    end

    command /usr/bin/fastfetch --config "$tmp" $image_args $argv
    set -l result $status
    rm -f "$tmp"
    return "$result"
end
