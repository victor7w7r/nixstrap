{ inputs, lib, ... }:
{
  imports = [ (inputs.den.namespace "tmux" false) ];

  den.default = {
    nixos =
      { isPersistent, user, ... }:
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
          terminal = "tmux-256color";
          shell = "${pkgs.zsh}/bin/zsh";
        };
      };
  };
}
