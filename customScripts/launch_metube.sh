#!/bin/bash
# ============================================
#   Launch MeTube from Parent Folder
# ============================================

set -e  # Exit on error

# Trap SIGINT (Ctrl+C) and SIGTERM
trap 'echo "Shutting down MeTube..."; kill 0; exit' SIGINT SIGTERM

# Store the directory where videos are saved
VIDEO_DIR="~/work-linux/media/yt-videos"
METUBE_DIR="/home/nuwa/work-linux/github-clones/MISCELLANEOUS/metube"

# MeTube environment name
METUBE_ENV="metube"

# Set MeTube to download to video directory
export DOWNLOAD_DIR="$VIDEO_DIR"
export STATE_DIR="$METUBE_DIR/.metube"
export MAX_CONCURRENT_DOWNLOADS=1
export DOWNLOAD_MODE=limited
# Add yt-dlp options for cookies
export YTDL_OPTIONS='{"cookiesfrombrowser": ["firefox"], "format": "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]", "js_runtimes": {"node": {"path": "/home/nuwa/miniforge3/envs/metube/bin/node"}}}'

# Kill any existing process on port 8081
echo "Checking for existing MeTube process on port 8081..."
if lsof -ti:8081 >/dev/null 2>&1; then
    echo "Killing process on port 8081..."
    kill $(lsof -ti:8081) 2>/dev/null || true
    sleep 1
fi

# Initialize mamba
eval "$(mamba shell hook --shell bash)"

# Check if metube environment exists, create if not
if ! mamba env list | grep -qw "$METUBE_ENV"; then
    echo "Creating mamba environment: $METUBE_ENV"
    mamba create -n "$METUBE_ENV" python=3.11 -y
    mamba activate "$METUBE_ENV"
    pip install uv
else
    echo "Activating existing mamba environment: $METUBE_ENV"
    mamba activate "$METUBE_ENV"
fi

# Change directory into the metube folder
cd "$METUBE_DIR"

# Tell uv to use system Python (our mamba env) instead of creating a venv
export UV_SYSTEM_PYTHON=1

# Sync Python dependencies
uv sync

# After uv sync
uv sync
uv add "yt-dlp" --upgrade-package yt-dlp   # keep yt-dlp current

echo ""
echo "=========================================="
echo "MeTube is starting with Firefox cookies..."
echo "Open http://localhost:8081 in your browser"
echo "Press Ctrl+C to stop"
echo "=========================================="
echo ""

# Run the backend
uv run python app/main.py
