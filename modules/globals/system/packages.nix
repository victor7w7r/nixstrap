{
  den.default = {
    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          atool
          brush
          choose
          clolcat
          cod
          file
          self'.packages.hf
          gnused
          gnutar
          inxi
          lemmeknow
          #loop
          lsof
          hexyl
          mommy
          p7zip
          phraze
          progress
          pv
          rsyncy
          sshfs
          sd
          sig
          sqlite
          self'.packages.texoxide
          tmux
          tre-command
          xz
        ];

        programs = {
          #bash.blesh.enable = true;
          less.enable = true;
          nano.enable = false;
          pay-respects.enable = true;
          skim.enable = true;
        };
      };

    nixos =
      {
        inputs',
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          with self'.packages;
          [
            #procmux
            #socktop
            busybox
            fatrace
            fsarchiver
            gdown
            inputs'.agenix.packages.default
            journalview
            killall
            kmon
            lazyjournal
            lazysys
            lnav
            modprobed-db
            pik
            s-tui
            self'.packages.open
            self'.packages.progressline
            systemctl-tui
            sysz
            watchexec
            zps
          ];
      };

    provides.to-users.homeManager =
      { lib, ... }:
      {
        programs = {
          command-not-found.enable = lib.mkDefault false;
          fd.enable = true;
          fish.generateCompletions = lib.mkDefault false;
          rclone.enable = true;
          ripgrep-all.enable = true;

          bat = {
            enable = true;
            config = {
              pager = "less -FR";
              theme = "Dracula";
              "italic-text" = "always";
              style = "numbers";
            };
          };

          btop = {
            enable = true;
            settings = {
              color_theme = "dracula";
              theme_background = false;
              update_ms = 500;
            };
          };

          eza = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
            colors = "always";
            extraOptions = [
              "--group-directories-first"
              "--header"
              "--no-quotes"
            ];
          };

          fzf = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
            defaultOptions = [
              "--height 40%"
              "--reverse"
              "--border"
              "--color=16"
            ];
            defaultCommand = "rg --files --hidden --glob=!.git/";
          };

          zoxide = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
            options = [ "--cmd cd" ];
          };
        };
      };
  };
}
