#!/usr/bin/env bash

EXTERNAL="HDMI-A-1"
LAPTOP="eDP-1"


# Get non-empty workspaces on the external monitor, sorted by ID
mapfile -t WORKSPACES < <(
    hyprctl -j workspaces \
    | jq -r --arg MON "$EXTERNAL" '
        map(select(.monitor == $MON and .windows > 0))
        | sort_by(.id)
        | .[].id
    '
)

TARGET_WS=1

for WS in "${WORKSPACES[@]}"; do
    # Move workspace WS to laptop
    hyprctl dispatch moveworkspacetomonitor "$WS" "$LAPTOP"

    # Renumber it to TARGET_WS
    hyprctl dispatch renameworkspace "$WS" "$TARGET_WS"

    ((TARGET_WS++))
done
