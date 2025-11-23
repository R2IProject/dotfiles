#!/bin/bash

# choice=$(echo -e "Free Window\nFull Screen\n❌ Cancel" | \
#     wofi --dmenu --prompt "Select Recording Mode:")
choice=$(echo -e "Free Window\nFull Screen\n❌ Cancel" | rofi -dmenu -p "Screen Record Mode:" -theme ~/.config/rofi/screenshot.rasi)
VIDEO_FILE=~/Videos/record-$(date +%s).mp4

case "$choice" in
    "Free Window")
        AREA=$(slurp)
        [ -z "$AREA" ] && exit 0
        wf-recorder --framerate 60 -f "$VIDEO_FILE" -g "$AREA"
        notify-send "Recording saved: $VIDEO_FILE"
        ;;
    "Full Screen")
        sleep 0.8
        wf-recorder --framerate 60 -f "$VIDEO_FILE"
        notify-send "Recording saved: $VIDEO_FILE"
        ;;
    "❌ Cancel" | *)
        exit 0
        ;;
esac
