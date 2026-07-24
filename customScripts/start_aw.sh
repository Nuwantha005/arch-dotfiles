#!/bin/bash
# Start the main tray and server
aw-qt & 

# Wait until the server is actually responding
until curl -s http://localhost:5600/api/0/info > /dev/null; do
  sleep 1
done

# Start the Hyprland watcher without the --name flag
aw-watcher-window-hyprland &
aw-watcher-input &
