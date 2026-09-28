#!/bin/bash

# 1. Run rofimoji in print mode to grab the selected emoji string cleanly
choice=$(~/.local/bin/rofimoji --action print)

# If a choice was made
if [[ -n "$choice" ]]; then
    # 2. Copy the emoji to the system clipboard cleanly as UTF-8
    echo -n "$choice" | wl-copy

    # 3. Small delay to ensure the clipboard is ready (Exactly like your cliphist script)
    sleep 0.2

    # 4. Simulate Ctrl+V to cleanly drop it into Obsidian
    wtype -M ctrl v -m ctrl
fi
