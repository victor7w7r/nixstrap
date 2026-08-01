{
  den.default = {
    os =
      { pkgs, self', ... }:
      {
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          atool
          brush
          choose
          cod
          file
          self'.packages.hf
          gnused
          gnutar
          lemmeknow
          #loop
          lsof
          hexyl
          mtools
          p7zip
          phraze
          progress
          pv
          rsyncy
          sshfs
          sd
          sig
          self'.packages.texoxide
          tmux
          tre-command
          udiskie
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
        isEfi,
        isPersistent,
        isTpm,
        lib,
        inputs',
        pkgs,
        self',
        ...
      }:
      {
        programs.nix-ld.enable = true;
        environment = {
          persistence = lib.optionalAttrs isPersistent {
            "/nix/persist".directories = [
              "/var/lib/containers"
              "/var/lib/nixos-containers"
              (lib.mkIf isTpm "/var/lib/sbctl")
            ];
          };
          systemPackages =
            with pkgs;
            [
              busybox
              btrfs-progs
              btdu
              exfatprogs
              gdown
              f2fs-tools
              fsarchiver
              killall
              modprobed-db
              inputs'.agenix.packages.default
              ntfs2btrfs
              #procmux
              self'.packages.progressline
            ]
            ++ lib.optionals isEfi [
              efibooteditor
              efibootmgr
            ]
            ++ lib.optionals isTpm [
              mokutil
              tpm2-tools
              sbctl
            ];
        };
      };

    provides.to-users.homeManager =
      {
        lib,
        pkgs,
        self',
        ...
      }:
      let
        cookies = pkgs.symlinkJoin {
          name = "fortune-cookies";
          paths = with self'.packages; [
            pkgs.fortune
            fortune-anti-jokes
            fortune-mod-archlinux
            fortune-mod-anarchism
            fortune-mod-bofh-excuses
            fortune-mod-billwurtz
            fortune-mod-canada-nctr
            fortune-mod-calvin
            fortune-mod-confucius
            fortune-mod-darkknight
            fortune-mod-dhammapada
            fortune-mod-doctorwho-classic-series
            fortune-mod-doctorwho-new-series
            fortune-mod-es
            fortune-mod-futurama
            fortune-mod-g
            fortune-mod-helluva
            fortune-mod-husse
            fortune-mod-issa-haiku
            fortune-mod-leftism
            fortune-mod-limetricks
            fortune-mod-matrix
            fortune-mod-portal-game
            fortune-mod-protolol
            fortune-mod-starwars
            fortune-mod-vimtips
          ];
        };
      in
      {
        home.packages = with pkgs; [
          inxi
          home-manager
          clolcat
          (pkgs.writeShellScriptBin "fortune" ''
            exec ${
              pkgs.fortune.override { withOffensive = true; }
            }/bin/fortune -s "${cookies}/share/games/fortunes" "$@"
          '')
          mommy
        ];

        programs = {
          fd.enable = true;
          ripgrep-all.enable = true;
          rclone.enable = true;

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

          command-not-found.enable = lib.mkDefault false;
          fish.generateCompletions = lib.mkDefault false;

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
