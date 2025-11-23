#!/usr/bin/env bash

declare -A DIRS=(
  ["Aylurs / AGS"]="$HOME/.config/ags"
  ["Hyprland"]="$HOME/.config/hypr"
  ["Waybar"]="$HOME/.config/hyprbar"
  ["Lazyvim / Neovim"]="$HOME/.config/nvim"
  ["Custom Launcher"]="$HOME/.config/Launcher"
  ["Rofi"]="$HOME/.config/rofi"
)

LABELS=$(printf "%s\n" "${!DIRS[@]}" | sort)
CHOICE=$(echo "$LABELS" | rofi -dmenu -p "Edit Config:" -theme ~/.config/rofi/screenshot.rasi -i)

# Exit if user cancels
[[ -z "$CHOICE" ]] && exit 0

TARGET="${DIRS[$CHOICE]}"
alacritty --working-directory "$TARGET" -e nvim . >/dev/null 2>&1 &
exit 0
