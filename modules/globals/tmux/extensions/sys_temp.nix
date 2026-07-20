{
  tmux.ext.string.temp = ''
    get_temp() {
      if grep -q "Raspberry" /proc/device-tree/model 2>/dev/null; then
        echo "$(vcgencmd measure_temp | sed 's/temp=//')"
      else
        echo "$(( $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0) / 1000 ))°C"
      fi
    }

    main() {
      echo "$(get_temp)"
      sleep 5
    }

    main
  '';
}
