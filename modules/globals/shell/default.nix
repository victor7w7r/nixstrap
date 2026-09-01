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
        programs.zsh.enable = true;
        environment = lib.mkMerge [
          {
            pathsToLink = [ "/share/zsh" ];
          }
          (lib.mkIf isPersistent {
            persistence."/nix/persist".users."${user.name}" = {
              files = [
                ".zsh_history"
                ".bash_history"
              ];
              directories = [
                ".local/share/atuin"
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
        enable = true;
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

      atuin = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        flags = [
          "--disable-up-arrow"
          "--disable-ctrl-r"
        ];
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "http://100.64.0.1:8888";
          search_mode = "fuzzy";
          keymap_mode = "vim-insert";
          update_check = "false";
          style = "compact";
          theme = {
            name = "autumn";
          };
        };
      };
    };
  };
}
