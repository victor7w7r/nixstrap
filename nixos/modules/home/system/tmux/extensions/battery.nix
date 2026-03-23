''
  linux_acpi() {
    arg=$1
    BAT=$(ls -d /sys/class/power_supply/*)
    if [ ! -x "$(which acpi 2>/dev/null)" ]; then
      for DEV in $BAT; do
        case "$arg" in
        status)
          [ -f "$DEV/status" ] && cat "$DEV/status"
          ;;
        percent)
          [ -f "$DEV/capacity" ] && cat "$DEV/capacity"
          ;;
        *) ;;
        esac
      done
    else
      case "$arg" in
      status)
        acpi | cut -d: -f2- | cut -d, -f1 | tr -d ' '
        ;;
      percent)
        acpi | cut -d: -f2- | cut -d, -f2 | tr -d '% '
        ;;
      *) ;;
      esac
    fi
  }

  battery_percent() {
    case $(uname -s) in
    Linux)
      percent=$(linux_acpi percent)
      [ -n "$percent" ] && echo "$percent%"
      ;;
    Darwin) pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%' ;;
    FreeBSD) apm | sed '8,11d' | grep life | awk '{print $4}' ;;
    *) ;;
    esac
  }

  battery_status() {
    case $(uname -s) in
    Linux) status=$(linux_acpi status) ;;
    Darwin) status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2 | tr -d " ") ;;
    FreeBSD) status=$(apm | sed '8,11d' | grep Status | awk '{printf $3}') ;;
    *) ;;
    esac

    tmp_bat_perc=$(battery_percent)
    bat_perc="''${tmp_bat_perc%\%}"

    case $status in
    discharging | Discharging)
      declare -A battery_labels=(
        [0]="󰂎"
        [10]="󰁺"
        [20]="󰁻"
        [30]="󰁼"
        [40]="󰁽"
        [50]="󰁾"
        [60]="󰁿"
        [70]="󰂀"
        [80]="󰂁"
        [90]="󰂂"
        [100]="󰁹"
      )
      echo "''${battery_labels[$((bat_perc / 10 * 10))]:-󰂃}"
      ;;
    high | charged | Full) echo "󰁹" ;;
    charging | Charging)
      declare -A battery_labels=(
        [0]="󰢟"
        [10]="󰢜"
        [20]="󰂆"
        [30]="󰂇"
        [40]="󰂈"
        [50]="󰢝"
        [60]="󰂉"
        [70]="󰢞"
        [80]="󰂊"
        [90]="󰂋"
        [100]="󰂅"
      )
      echo "''${battery_labels[$((bat_perc / 10 * 10))]:-󰂃}"
      ;;
    ACattached) echo '' ;;
    finishingcharge) echo '󰂅' ;;
    *) echo '' ;;
    esac
  }

  battery_exec() {
    bat_stat=$(battery_status)
    bat_perc=$(battery_percent)

    if [ -z "$bat_stat" ]; then
      echo "$bat_perc"
    elif [ -z "$bat_perc" ]; then
      echo ""
    else
      echo "$bat_stat $bat_perc"
    fi
  }
''
