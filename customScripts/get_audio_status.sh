#!/bin/bash
CURRENT_SINK=$(pactl get-default-sink)

if [[ "$CURRENT_SINK" == *"bluez_output"* ]]; then
    echo "🎧 Bluetooth"
elif [[ "$CURRENT_SINK" == *"alsa_output"* ]]; then
    echo "💻 Speakers"
else
    echo "Unknown"
fi
