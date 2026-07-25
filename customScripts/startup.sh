#!/bin/bash
# ============================================================
# ~/customScripts/startup.sh
# Runs once on Hyprland login via exec-once
# ============================================================

# Give Hyprland a moment to fully initialize before dispatching
sleep 2

# ---- Helper: poll hyprctl until a window with matching class appears ----
# Returns the window address, or empty string on timeout
wait_for_window() {
    local class_pattern="$1"
    local max_attempts=60   # 30 seconds max (60 × 0.5s)
    local i=0

    while [ $i -lt $max_attempts ]; do
        local addr
        addr=$(hyprctl clients -j 2>/dev/null \
            | jq -r ".[] | select(.class | test(\"$class_pattern\"; \"i\")) | .address" \
            | head -1)

        if [ -n "$addr" ]; then
            echo "$addr"
            return 0
        fi

        sleep 0.5
        i=$((i + 1))
    done

    echo ""
    return 1
}

# ============================================================
# 1. MOUNT DRIVES
#    udisksctl doesn't need sudo, unlike mount
# ============================================================
echo "[startup] Mounting drives..."
udisksctl mount -b /dev/nvme0n1p3 2>/dev/null && echo "  ✓ System mounted"   || echo "  - System already mounted"
udisksctl mount -b /dev/nvme0n1p6 2>/dev/null && echo "  ✓ Work mounted"      || echo "  - Work already mounted"

# ============================================================
# 2. FIREFOX NIGHTLY → HDMI-A-1, workspace 1
#    Pre-focus the external monitor so the app opens there
# ============================================================
echo "[startup] Launching Firefox Nightly on HDMI-A-1..."
hyprctl dispatch "hl.dsp.focus({ monitor = 'HDMI-A-1' })"
sleep 0.3
hyprctl dispatch "hl.dsp.focus({ workspace = 1 })"
sleep 0.3
firefox-nightly &

# ============================================================
# 3. OBSIDIAN → special:special
#    Launch, wait for window to appear, then silently move it
# ============================================================
echo "[startup] Launching Obsidian..."
obsidian &
addr=$(wait_for_window "obsidian")

if [ -n "$addr" ]; then
    hyprctl dispatch "hl.dsp.window.move({ workspace = 'special:special', window = 'address:$addr' })"
    echo "  ✓ Obsidian moved to special:special"
else
    echo "  ✗ Timed out waiting for Obsidian"
fi

# ============================================================
# 4. THUNAR (file manager) → eDP-1 (laptop screen), workspace 1
#    Sleep first to let Hyprland settle after the special workspace move
# ============================================================
echo "[startup] Launching Thunar on eDP-1..."
sleep 1
hyprctl dispatch "hl.dsp.focus({ monitor = 'eDP-1' })"
sleep 0.3
hyprctl dispatch "hl.dsp.focus({ workspace = 1 })"   # explicitly leave special workspace
sleep 0.5
thunar &

echo "[startup] Done."
