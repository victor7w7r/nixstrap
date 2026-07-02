{
  inputs,
  lib,
  tmux,
  ...
}:
{
  imports = [ (inputs.den.namespace "tmux" false) ];

  den.default =
    { user, ... }:
    {
      nixos =
        { isPersistent, ... }:
        lib.optionalAttrs isPersistent {
          environment.persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [ ".tmux" ];
        };

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          programs.tmux = {
            enable = true;
            baseIndex = 1;
            aggressiveResize = true;
            disableConfirmationPrompt = true;
            clock24 = false;
            escapeTime = 0;
            historyLimit = 100000;
            keyMode = "vi";
            mouse = true;
            prefix = "C-a";
            sensibleOnTop = false;
            shell = "${pkgs.zsh}/bin/zsh";
            extraConfig = ''
              run ${
                pkgs.writeShellScript "status" (
                  tmux.shell.status {
                    git = pkgs.writeShellScript "git-ext" tmux.ext.string.git;
                    ssh = pkgs.writeShellScript "ssh-ext" tmux.ext.string.ssh;
                    colors = pkgs.writeShellScript "colors-ext" tmux.ext.string.colors;
                    network = pkgs.writeShellScript "network-ping" tmux.ext.string.network-ping;
                    ram = pkgs.writeShellScript "ram-ext" tmux.ext.string.ram-ping;
                    cpu = pkgs.writeShellScript "cpu-ext" tmux.ext.string.cpu-info;
                    battery = pkgs.writeShellScript "battery-ext" tmux.ext.string.battery;
                  }
                )
              }
              run -b ${pkgs.writeShellScript "foreground" tmux.shell.string.foreground}
              run -b ${pkgs.writeShellScript "colors" tmux.shell.string.colors}
            '';
          };
        };
    };
}
