#!/usr/bin/env bash

airplane_mode() {
  if nmcli nm | grep "Airplane mode" | grep -q "enabled"; then
      nmcli nm airplane mode off
  else
      nmcli nm airplane mode on
  fi
}

# dispatcher
case "$1" in
  airplane_mode) airplane_mode ;;
esac
