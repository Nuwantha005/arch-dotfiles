#!/bin/bash

# Define the path to your new dedicated CSS
STYLE="$HOME/.config/wofi/clipboard.css"

# Run wofi with the -s flag to point to the new style
# We also use --width and --height here so it doesn't rely on the global 'config' file
choice=$(cliphist list | wofi --dmenu \
    --style "$STYLE" \
    --width 600 \
    --height 400 \
    --prompt "📋 Clipboard History" \
    --allow-markup \
    --cache-file /dev/null)

if [[ -n "$choice" ]]; then
    # 2. Decode and copy to the system clipboard
    echo "$choice" | cliphist decode | wl-copy

    # 3. Small delay to ensure the clipboard is "ready" before we hit paste
    sleep 0.2

    # 4. Simulate Ctrl+V (Standard for most GUI apps and editors)
    wtype -M ctrl v -m ctrl
fi
