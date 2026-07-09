{
  den.aspects.dev.ccache.nixos =
    { pkgs, ... }:
    (pkgs.writeText "ccache.conf" ''
      compression = false
      file_clone = true
      max_size = 25G
      sloppiness = random_seed
      umask = 007
      compiler_check = content
    '')
    |> (conf: {
      nixpkgs.overlays = [
        (final: _: {
          ccacheWrapper = final.ccacheWrapper.override {
            extraConfig = ''
              CCACHE_DIR="/nix/var/cache/ccache"
              export CCACHE_CONFIGPATH="''${CCACHE_CONFIGPATH:-${conf}}"
              if [ ! -d "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' does not exist"
                echo "Please create it with:"
                echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
                echo "  sudo chown root:nixbld '$CCACHE_DIR'"
                echo "====="
                exit 1
              fi
              if [ ! -w "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
                echo "Please verify its access permissions"
                echo "====="
                exit 1
              fi
            '';
          };
        })
      ];

      systemd.tmpfiles.rules = [ "L+ /nix/var/cache/ccache/ccache.conf - - - - ${conf}" ];

      nix.settings.extra-sandbox-paths = [
        "/nix/var/cache/ccache"
        "/nix/var/cache/sccache"
      ];

      programs.ccache = {
        enable = true;
        cacheDir = "/nix/var/cache/ccache";
      };
    });
}
