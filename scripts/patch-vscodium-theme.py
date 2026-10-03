#!/usr/bin/env python3
"""Apply Noctalia's generated opacity policy to installed VSCodium themes."""

import argparse
import json
import os
from pathlib import Path
import re
import stat
import tempfile


def patch_theme(path, overrides):
    theme = json.loads(path.read_text())
    colors = theme["colors"]
    updated = dict(colors)
    default_alpha = overrides.get("_defaultBackgroundAlpha")
    if default_alpha is not None:
        if not re.fullmatch(r"[0-9a-fA-F]{2}", default_alpha):
            raise ValueError(f"Invalid default background alpha: {default_alpha!r}")
        limit = int(default_alpha, 16)
        for token, color in colors.items():
            if "background" not in token.lower():
                continue
            if not isinstance(color, str) or not re.fullmatch(
                r"#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?", color
            ):
                continue
            current_alpha = int(color[-2:], 16) if len(color) == 9 else 255
            updated[token] = color[:7] + f"{min(current_alpha, limit):02X}"
    for token, fallback in overrides.items():
        if token == "_defaultBackgroundAlpha":
            continue
        if not re.fullmatch(r"#[0-9a-fA-F]{8}", fallback):
            raise ValueError(f"Invalid overlay color for {token}: {fallback!r}")
        original = colors.get(token, fallback)
        if token == "terminal.background":
            updated[token] = fallback
        elif re.fullmatch(r"#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?", original):
            updated[token] = original[:7] + fallback[-2:]
        else:
            raise ValueError(f"Invalid theme color for {token}: {original!r}")
    if updated == colors:
        return False
    theme["colors"] = updated
    # Write beside the theme and replace atomically, so the editor never reads
    # a partially written JSON file. Keep the existing file permissions.
    temp_path = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as output:
            temp_path = Path(output.name)
            json.dump(theme, output, indent=4, ensure_ascii=False)
            output.write("\n")
            os.fchmod(output.fileno(), stat.S_IMODE(path.stat().st_mode))
        os.replace(temp_path, path)
    finally:
        if temp_path is not None:
            temp_path.unlink(missing_ok=True)
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("overlay", type=Path, help="Noctalia-generated opacity overlay JSON")
    parser.add_argument("--extensions-dir", type=Path,
                        default=Path.home() / ".vscode-oss/extensions")
    args = parser.parse_args()
    overrides = json.loads(args.overlay.read_text())
    paths = sorted(args.extensions_dir.glob(
        "noctalia.noctaliatheme-*/themes/NoctaliaTheme-color-theme.json"))
    for path in paths:
        if patch_theme(path, overrides):
            print(f"Patched {path}")


if __name__ == "__main__":
    main()
