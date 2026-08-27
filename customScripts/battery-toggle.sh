#!/bin/bash

# Find the battery threshold file
BAT_PATH="/sys/class/power_supply/BAT0/charge_control_end_threshold"
if [ ! -f "$BAT_PATH" ]; then
    for b in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
        if [ -f "$b" ]; then
            BAT_PATH="$b"
            break
        fi
    done
fi

TARGET="$1"

# Handle 'get' or 'status' query
if [ "$TARGET" = "get" ] || [ "$TARGET" = "status" ]; then
    if [ -f "$BAT_PATH" ]; then
        cat "$BAT_PATH"
    else
        echo 100
    fi
    exit 0
fi

# Set target threshold: 60, 80, or 100
if [ "$TARGET" = "60" ] || [ "$TARGET" = "80" ] || [ "$TARGET" = "100" ]; then
    echo "$TARGET" | sudo tee "$BAT_PATH" > /dev/null
    case "$TARGET" in
        60)
            notify-send -r 9991 -i battery-low "Battery Mode" "Switched to Lifespan Mode (60%)"
            ;;
        80)
            notify-send -r 9991 -i battery-charging "Battery Mode" "Switched to Balanced Mode (80%)"
            ;;
        100)
            notify-send -r 9991 -i battery-full "Battery Mode" "Switched to Travel Mode (100%)"
            ;;
    esac
else
    # Default cycle if no valid argument is given
    CURRENT=$(cat "$BAT_PATH" 2>/dev/null || echo 100)
    if [ "$CURRENT" = "60" ]; then
        "$0" 80
    elif [ "$CURRENT" = "80" ]; then
        "$0" 100
    else
        "$0" 60
    fi
fi
