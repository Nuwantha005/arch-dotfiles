#!/bin/bash

# Path to the battery threshold file
BAT_PATH="/sys/class/power_supply/BAT0/charge_control_end_threshold"

# Read the current value
CURRENT=$(cat "$BAT_PATH")

if [ "$CURRENT" -eq 60 ]; then
    # Switch to 100%
    echo 100 | sudo tee "$BAT_PATH"
    notify-send -r 9991 -i battery-full "Battery Mode" "Switched to Travel Mode (100%)"
else
    # Switch to 60%
    echo 60 | sudo tee "$BAT_PATH"
    notify-send -r 9991 -i battery-low "Battery Mode" "Switched to Lifespan Mode (60%)"
fi
