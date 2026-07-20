{
  tmux.ext.string.cpu-info = pkgs: ''
    normalize_percent_len() {
      max_len=5
      percent_len=''${#1}
      let diff_len=$max_len-$percent_len
      let left_spaces=($diff_len + 1)/2
      let right_spaces=($diff_len)/2
      printf "%''${left_spaces}s%s%''${right_spaces}s\n" "" $1 ""
    }

    get_percent() {
      case $(uname -s) in
      Linux)
        percent=$(mpstat 1 1 | awk 'END{print 100 - $NF "%"}')
        normalize_percent_len "$percent"
        ;;

      Darwin)
        cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
        cpucores=$(sysctl -n hw.logicalcpu)
        cpuusage=$((cpuvalue / cpucores))
        percent="$cpuusage%"
        normalize_percent_len $percent
        ;;

      OpenBSD)
        cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
        cpucores=$(sysctl -n hw.ncpuonline)
        cpuusage=$((cpuvalue / cpucores))
        percent="$cpuusage%"
        normalize_percent_len $percent
        ;;

      CYGWIN* | MINGW32* | MSYS* | MINGW*) ;;
      esac
    }

    echo "$(get_percent)" && sleep 2
  '';
}
