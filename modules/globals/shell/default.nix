{
  den.default = {
    nixos =
      {
        isPersistent,
        lib,
        user,
        ...
      }:
      {
        environment = lib.mkMerge [
          {
            programs.zsh.enable = true;
            pathsToLink = [ "/share/zsh" ];
          }
          (lib.mkIf isPersistent {
            persistence."/nix/persist".users."${user.name}" = {
              files = [
                ".zsh_history"
                ".bash_history"
              ];
              directories = [
                ".cache/antidote"
                ".zsh"
              ];
            };
          })
        ];
      };

    provides.to-users.homeManager.programs = {
      intelli-shell.enable = true;
      bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        historyControl = [ "erasedups" ];
        historyFileSize = 1000000;
        historySize = 10000;
        historyIgnore = [
          "ls"
          "cd"
          "exit"
        ];
      };
      #https://github.com/poetaman/arttime
      zsh = {
        autocd = true;
        enableCompletion = true;
        autosuggestion.enable = true;

        syntaxHighlighting = {
          enable = true;
          styles = {
            "alias" = "fg=magenta,bold";
            "command" = "fg=cyan";
          };
        };
        history = {
          extended = true;
          path = "$HOME/.zsh_history";
          save = 10000;
          size = 10000;
          share = true;
        };
        dirHashes = {
          docs = "$HOME/Documentos";
        };
        cdpath = [ "~/repositories/snowflake" ];
      };
    };
  };
}
