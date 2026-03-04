#!/usr/bin/env bash

commandexist() {
  command -v "$1" &>/dev/null
}

main() {
  if ! commandexist mommy; then
    echo ""
    return
  fi

  LAST_EXIT=${LAST_EXIT:-""}
  LAST_CMD_TS=${LAST_CMD_TS:-0}
  TS_FILE="/tmp/.last_cmd_ts_seen"
  MESSAGE_FILE="/tmp/.last_cmd_message"

  if [[ -n "$IS_ZSH" ]]; then
    echo ""
    return
  fi

  if [[ -f "$TS_FILE" ]]; then
    LAST_PROCESSED_TS=$(cat "$TS_FILE")
  else
    LAST_PROCESSED_TS=0
  fi

  if (( LAST_CMD_TS > LAST_PROCESSED_TS )); then
    echo "$LAST_CMD_TS" > "$TS_FILE"
    RES=$(mommy -c "$HOME/.config/tmux/mommy.conf" -1 -s "$LAST_EXIT")
    echo "$RES" > "$MESSAGE_FILE"
    echo "  $RES"
  else
    RES=$(cat "$MESSAGE_FILE")
    echo "  $RES"
  fi
}

main
sleep 1