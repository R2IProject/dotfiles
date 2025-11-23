#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

# choice=$(echo -e "📸 Full Screen\n📐 Select Area\n❌ Cancel" | wofi --dmenu --prompt "Select Screenshot Mode:")
choice=$(echo -e "Full Screen\nSelect Area\n❌ Cancel" | rofi -dmenu -p "Screenshot Mode:" -theme ~/.config/rofi/screenshot.rasi)

case "$choice" in
"Full Screen")
  sleep 0.8
  grim "$FILE" && wl-copy <"$FILE"
  notify-send "📸 Screenshot Taken" "Saved and copied to clipboard:\n$FILE"
  ;;
"Select Area")
  GEOM=$(slurp)
  # If user pressed Esc, slurp returns empty → cancel safely
  if [ -z "$GEOM" ]; then
    notify-send "❌ Screenshot cancelled"
    exit 0
  fi

  grim -g "$GEOM" "$FILE" && wl-copy <"$FILE"
  notify-send "📐 Screenshot Taken" "Saved and copied to clipboard:\n$FILE"
  ;;
*)
  exit 0
  ;;
esac
