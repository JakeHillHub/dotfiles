#!/bin/bash

# --- Configuration ---
CONFIG_FILE="$HOME/dotfiles/gpu-screen-recorder/gpu-screen-recorder.conf"
OUTPUT_DIR="$HOME/Videos"
OUTPUT_FILE="$OUTPUT_DIR/recording_$(date +%F_%H-%M-%S).mp4"
FPS=60

if pgrep -f "gpu-screen-recorder -w" >/dev/null; then
  pkill -SIGINT -f "gpu-screen-recorder -w"
  notify-send "Recording Stopped" "Video saved to ${OUTPUT_FILE}"
else
  # Get the monitor scale factor from hyprctl
  scale=$(hyprctl monitors -j | jq -r '.[0].scale')

  # Execute slurp to get the selection in logical coordinates (e.g., 283,215 69x211)
  slurp_output=$(slurp)

  # Parse and scale the coordinates to physical pixels
  # slurp format: X,Y WxH -> need to multiply all values by scale
  gpu_region_string=$(echo "$slurp_output" | awk -v s="$scale" -F'[, x]' '{
    x = int($1 * s)
    y = int($2 * s)
    w = int($3 * s)
    h = int($4 * s)
    printf "%dx%d+%d+%d", w, h, x, y
  }')

  # Check if a region was actually selected (slurp output is often empty if cancelled)
  if [ -z "$gpu_region_string" ]; then
    notify-send "Recording cancelled or no region selected."
  else
    notify-send "Starting recording for region: $gpu_region_string"

    # Set the environment variable to point to the configuration file
    GSR_CONFIG="$CONFIG_FILE" gpu-screen-recorder \
      -w region \
      -f "$FPS" \
      -c mkv \
      -o "$OUTPUT_FILE" \
      -region "$gpu_region_string"
  fi
fi
