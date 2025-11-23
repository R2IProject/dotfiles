#!/usr/bin/env bash

RECENT_DIRS="$HOME/.config/Launcher/bin/nvim_rofi_recent.txt"
mkdir -p "$(dirname "$RECENT_DIRS")"

show_recent() {
  [[ ! -f "$RECENT_DIRS" ]] && exit 0

  TRANSFORMED=$(tac "$RECENT_DIRS" | while read -r line; do
    BASENAME=$(basename "$line")
    echo "${BASENAME^}"
  done)

  CHOICE=$(echo "$TRANSFORMED" | rofi -dmenu -p "Recent dirs:" -i)
  TARGET=$(grep -i "/${CHOICE,,}$" "$RECENT_DIRS" | tail -n1)
  echo "$TARGET"
}

browse_path() {
  local CUR="$HOME"
  local ROOT="$HOME"

  while true; do
    ITEMS=()
    ITEMS+=("[Open Dir Here]")
    [[ "$CUR" != "$ROOT" ]] && ITEMS+=("..") # go back
    mapfile -t DIRS < <(ls -1p "$CUR" 2>/dev/null)
    ITEMS+=("${DIRS[@]}")
    CHOICE=$(printf "%s\n" "${ITEMS[@]}" | rofi -dmenu -p "Open nvim:" -i)
    [[ -z "$CHOICE" ]] && exit 0

    if [[ "$CHOICE" == ".." ]]; then
      CUR=$(dirname "$CUR")
    elif [[ "$CHOICE" == "[Open Dir Here]" ]]; then
      echo "$CUR"
      return
    else
      local TARGET="$CUR/$CHOICE"
      TARGET="${TARGET%/}"

      if [[ -d "$TARGET" ]]; then
        CUR="$TARGET"
      else
        echo "$TARGET"
        return
      fi
    fi
  done
}

if [[ "$ROFI_INFO" == "recent" ]]; then
  TARGET=$(show_recent)
else
  TARGET=$(browse_path)
fi

[[ -z "$TARGET" ]] && exit 0

TARGET=$(readlink -f "$TARGET" 2>/dev/null || echo "$TARGET")
TARGET="${TARGET%/}"

if [[ -d "$TARGET" ]]; then
  grep -vFx "$TARGET" "$RECENT_DIRS" 2>/dev/null >"$RECENT_DIRS.tmp"
  echo "$TARGET" >>"$RECENT_DIRS.tmp"
  mv "$RECENT_DIRS.tmp" "$RECENT_DIRS"
fi

if [[ -d "$TARGET" ]]; then
  alacritty --working-directory "$TARGET" -e nvim . &
else
  alacritty --working-directory "$(dirname "$TARGET")" -e nvim "$TARGET" &
fi

exit 0
