#!/usr/bin/env python3
"""Keep the F1 indicator in sync with the default PipeWire output."""

import subprocess
import sys


def sync():
    volume = subprocess.check_output(
        ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], text=True
    )
    subprocess.run(
        [
            "busctl", "--system", "call", "org.freedesktop.login1",
            "/org/freedesktop/login1/session/auto",
            "org.freedesktop.login1.Session", "SetBrightness", "ssu",
            "leds", "platform::mute", "1" if "[MUTED]" in volume else "0",
        ],
        check=True,
    )


if "--once" in sys.argv:
    sync()
else:
    with subprocess.Popen(
        ["pactl", "subscribe"], stdout=subprocess.PIPE, text=True
    ) as events:
        try:
            sync()
            for event in events.stdout:
                if any(kind in event for kind in ("on sink #", "on server #", "on card #")):
                    sync()
            raise SystemExit(events.wait() or 1)
        finally:
            events.terminate()
