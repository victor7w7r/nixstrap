{ lib, tmux, ... }:
{
  den.default.provides.to-users.homeManager = { pkgs, ... }: {
    programs.tmux.extraConfig =
      let
        git = pkgs.writeShellScript "git-ext" tmux.ext.string.git;
        ssh = pkgs.writeShellScript "ssh-ext" tmux.ext.string.ssh;
        colors = pkgs.writeShellScript "colors-ext" tmux.ext.string.colors;
        network = pkgs.writeShellScript "network-ping" tmux.ext.string.network-ping;
        ram = pkgs.writeShellScript "ram-ext" tmux.ext.string.ram-ping;
        cpu = pkgs.writeShellScript "cpu-ext" (tmux.ext.string.cpu-info pkgs);
        battery = pkgs.writeShellScript "battery-ext" tmux.ext.string.battery;
        temp = pkgs.writeShellScript "temp-ext" tmux.ext.string.temp;
      in
      lib.mkOrder 400 ''
        run ${pkgs.writeShellScript "status" ''
          ${tmux.shell.string.palette}
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
          right_status "#(${colors} 4)" "#(${temp})"
          right_status "#(${colors} 5)" "#(${cpu})"
          right_status "#(${colors} 6)" "#(${battery})"
          right_status "#(${colors} 0)" "#(date +'%%-d/%%-m - %%I:%%M ')"
          #right_status "#(colors_exec 3)" "#($ext/extensions/mommy.sh)"
          #right_status "#e4cfff" "#($current_dir/network.sh)"
          #right_status "#e4cfff" "#($current_dir/mpc.sh)"
          #right_status "#e4cfff" "#($current_dir/sys_temp.sh)"
        ''}
        run -b ${pkgs.writeShellScript "foreground" tmux.shell.string.foreground}
        run -b ${pkgs.writeShellScript "colors" tmux.shell.string.colors}
      '';
  };
}
