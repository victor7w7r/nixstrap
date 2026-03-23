{ pkgs, ... }:
pkgs.writeShellScript "colors-ext" ''
  if [ -d /dev/shm ]; then
    CACHE_FILE="/dev/shm/colors.exectmux"
  else
    CACHE_FILE="/tmp/colors.exectmux"
  fi

  colorsarr=()

  if [ ! -f "$CACHE_FILE" ]; then
    colorsarr=("''${colors_cake[@]}")
  else
    while IFS= read -r line; do colorsarr+=("$line"); done <"$CACHE_FILE"
  fi

  echo "''${colorsarr[$1]}"
  fg
''
