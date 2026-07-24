#!/bin/bash
# ~/.config/hypr/Scripts/swap_workspaces.sh

# The relative number (1-10) passed from your keybind
RELATIVE_TARGET=$1

# 1. Get the current active workspace ID
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# 2. Calculate the 'Base' for the current monitor's workspace set
# If current is 1-10, base is 0. If current is 11-20, base is 10.
# Logic: ((Current - 1) / 10) * 10
BASE=$(( ((CURRENT_WS - 1) / 10) * 10 ))

# 3. Calculate the actual Absolute Target ID
# e.g., if you are on WS 13, BASE is 10. Target 5 becomes 15.
TARGET_WS=$(( BASE + RELATIVE_TARGET ))

# If we are already on the target, just exit
if [ "$CURRENT_WS" -eq "$TARGET_WS" ]; then
    exit 0
fi

# 4. SWAP WINDOWS (The "Temp Workspace" Shuffle)
# This moves windows, not the workspace itself, to respect hyprsplit boundaries.

TEMP_WS=99 # Use a workspace ID far outside your normal range

# Move all windows from CURRENT to TEMP
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $CURRENT_WS) | .address" | xargs -I {} hyprctl dispatch movetoworkspacesilent $TEMP_WS,address:{}

# Move all windows from TARGET to CURRENT
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $TARGET_WS) | .address" | xargs -I {} hyprctl dispatch movetoworkspacesilent $CURRENT_WS,address:{}

# Move all windows from TEMP to TARGET
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $TEMP_WS) | .address" | xargs -I {} hyprctl dispatch movetoworkspacesilent $TARGET_WS,address:{}

# 5. Focus the target workspace
hyprctl dispatch workspace $TARGET_WS
