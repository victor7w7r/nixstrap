{ pkgs, ... }:
pkgs.writeShellScript "status" ''
  ${(import ../extensions/colors.nix)}
  ${(import ../extensions/git.nix)}
  ${(import ../extensions/ssh_sesion.nix)}
  ${(import ../extensions/network_ping.nix)}
  ${(import ../extensions/ram_info.nix)}
  ${(import ../extensions/cpu_info.nix)}
  ${(import ../extensions/battery.nix)}

  right_status() {
    local color="$1"
    local text="$2"
    tmux set-option -ga status-right \
        "#{?#{==:''${text},},,#[fg=''${color}] #[fg=#cdd6f4]#[bg=''${color}] ''${text}}"
  }

  right_status "#(colors_exec 0)" "#(git_exec)"
  right_status "#(colors_exec 1)" "#(ssh_exec)"
  right_status "#(colors_exec 2)" "#(ping_exec)"
  right_status "#(colors_exec 3)" "#(ram_exec)"
  right_status "#(colors_exec 4)" "#(cpu_exec)"
  right_status "#(colors_exec 5)" "#(battery_exec)"
  right_status "#(colors_exec 6)" "%%d-%b %I:%M%P "
  #right_status "#(colors_exec 3)" "#($ext/extensions/mommy.sh)"
  #right_status "#e4cfff" "#($current_dir/network.sh)"
  #right_status "#e4cfff" "#($current_dir/mpc.sh)"
  #right_status "#e4cfff" "#($current_dir/sys_temp.sh)"
''
