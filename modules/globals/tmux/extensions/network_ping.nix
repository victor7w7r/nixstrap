{
  tmux.ext.string.network-ping = ''
    ping_function() {
      case $(uname -s) in
      Linux | Darwin)
        if pingtime=$(ping -c 1 -W 2 "8.8.8.8" 2>/dev/null | tail -1 | awk -F'/' '{printf "%.0f\n", $5}') && [ -n "$pingtime" ]; then
          echo "''${pingtime}ms"
        else
          echo "0ms"
        fi
        ;;
      CYGWIN* | MINGW32* | MSYS* | MINGW*) ;;
      esac
    }
    ping_function
    sleep 3
  '';
}
