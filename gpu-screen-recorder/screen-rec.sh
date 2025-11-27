#!/bin/bash

# --- Configuration ---
CONFIG_FILE="$HOME/dotfiles/gpu-screen-recorder/gpu-screen-recorder.conf"
OUTPUT_DIR="$HOME/Videos"
OUTPUT_FILE="$OUTPUT_DIR/recording_$(date +%F_%H-%M-%S).mp4"
FPS=60

if pgrep -x "gpu-screen-recorder" >/dev/null; then
  pkill -SIGINT -x "gpu-screen-recorder"
  notify-send "Recording Stopped" "Video saved."
else
  # Execute slurp to get the selection (e.g., 283,215 69x211)
  # Pipe to sed to reformat to WxH+X+Y (e.g., 69x211+283+215)
  # Use a temporary variable to store the result
  gpu_region_string=$(slurp | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')

  # Check if a region was actually selected (slurp output is often empty if cancelled)
  if [ -z "$gpu_region_string" ]; then
    echo "Recording cancelled or no region selected."
  else
    echo "Starting recording for region: $gpu_region_string"

    # Set the environment variable to point to the configuration file
    GSR_CONFIG="$CONFIG_FILE" gpu-screen-recorder \
      -w region \
      -f "$FPS" \
      -c mkv \
      -o "$OUTPUT_FILE" \
      -region "$gpu_region_string"
  fi
fi
