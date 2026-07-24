#!/bin/bash
# --- CONFIGURATION ---
INTERNAL_SINK="alsa_output.pci-0000_03_00.6.analog-stereo"
BLUETOOTH_MAC="C3:65:B5:FD:D1:56" 
# ---------------------

# 1. Helper Variables
BT_CARD="bluez_card.${BLUETOOTH_MAC//:/_}"
CURRENT_SINK=$(pactl get-default-sink)

# 2. Function to find the Sink Name dynamically (tries BOTH formats)
get_bt_sink() {
    local sink
    # Try with colons first (most common in PipeWire)
    sink=$(pactl list sinks short | grep "bluez_output.${BLUETOOTH_MAC}" | awk '{print $2}')
    
    # If not found, try with underscores
    if [ -z "$sink" ]; then
        sink=$(pactl list sinks short | grep "bluez_output.${BLUETOOTH_MAC//:/_}" | awk '{print $2}')
    fi
    
    # If still not found, try ANY bluez sink (fallback)
    if [ -z "$sink" ]; then
        sink=$(pactl list sinks short | grep "bluez_output" | head -n1 | awk '{print $2}')
    fi
    
    echo "$sink"
}

# 3. Main Logic
if [ "$CURRENT_SINK" == "$INTERNAL_SINK" ]; then
    # >> CASE: Switching TO Bluetooth
    
    # Ensure Bluetooth is powered on
    if ! bluetoothctl show | grep -q "Powered: yes"; then
        notify-send "Bluetooth" "Powering on Bluetooth..."
        bluetoothctl power on
        sleep 2
    fi
    
    # Check if already connected (skip connection if yes)
    if bluetoothctl info "$BLUETOOTH_MAC" | grep -q "Connected: yes"; then
        notify-send "Bluetooth" "Already connected to earplugs ✓"
    else
        # Not connected - try to connect
        notify-send "Bluetooth" "Connecting to earplugs..."
        bluetoothctl connect "$BLUETOOTH_MAC"
        sleep 4
    fi
    
    # Check if Sink exists. If NOT, try to FORCE the card profile
    BLUETOOTH_SINK=$(get_bt_sink)
    
    if [ -z "$BLUETOOTH_SINK" ]; then
        # Device connected but no audio sink? Force A2DP profile.
        notify-send "Audio" "Forcing Audio Profile..."
        pactl set-card-profile "$BT_CARD" a2dp-sink
        sleep 2
        BLUETOOTH_SINK=$(get_bt_sink)
    fi
    
    # Final attempt to switch
    if [ -n "$BLUETOOTH_SINK" ]; then
        pactl set-default-sink "$BLUETOOTH_SINK"
        pactl set-sink-mute "$INTERNAL_SINK" 1
        notify-send "Audio" "Switched to Bluetooth 🎧"
    else
        notify-send "Audio Error" "Connected, but audio stream failed to initialize."
        # Debug: Show what sinks are available
        pactl list sinks short >> /tmp/audio_debug.log
    fi
else
    # >> CASE: Switching TO Speakers
    pactl set-default-sink "$INTERNAL_SINK"
    pactl set-sink-mute "$INTERNAL_SINK" 0
    notify-send "Audio" "Switched to Speakers 💻"
fi
