{ pkgs, ... }:
let
  colors = pkgs.callPackage ../extensions/colors.nix { };
  git = pkgs.callPackage ../extensions/git.nix { };
  ssh = pkgs.callPackage ../extensions/ssh_session.nix { };
  network = pkgs.callPackage ../extensions/network_ping.nix { };
  ram = pkgs.callPackage ../extensions/ram_info.nix { };
  cpu = pkgs.callPackage ../extensions/cpu_info.nix { };
  battery = pkgs.callPackage ../extensions/battery.nix { };
in
pkgs.writeShellScript "status" ''
  ${(import ./palette.nix)}

  right_status() {
    local color="$1"
    local text="$2"
    tmux set-option -ga status-right \
        "#{?#{==:''${text},},,#[fg=''${color}] #[fg=#cdd6f4]#[bg=''${color}] ''${text}}"
  }

  right_status "#(${colors} 0)" "#(${git})"
  right_status "#(${colors} 1)" "#(${ssh})"
  right_status "#(${colors} 2)" "#(${network})"
  right_status "#(${colors} 3)" "#(${ram})"
  right_status "#(${colors} 4)" "#(${cpu})"
  right_status "#(${colors} 5)" "#(${battery})"
  right_status "#(${colors} 6)" "%%d-%b %I:%M%P "
  #right_status "#(colors_exec 3)" "#($ext/extensions/mommy.sh)"
  #right_status "#e4cfff" "#($current_dir/network.sh)"
  #right_status "#e4cfff" "#($current_dir/mpc.sh)"
  #right_status "#e4cfff" "#($current_dir/sys_temp.sh)"
''
