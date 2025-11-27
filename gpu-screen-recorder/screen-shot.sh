#!/bin/bash

FILE="$HOME/Pictures/screenshot_$(date +%F_%H-%M-%S).png"
grim -g "$(slurp)" - | swappy -o $FILE -f -
notify-send "Saved to $FILE"
