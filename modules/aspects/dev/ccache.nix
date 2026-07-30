{
  den.aspects.dev.ccache.nixos =
    { pkgs, ... }:
    (pkgs.writeText "ccache.conf" ''
      compression = false
      file_clone = true
      max_size = 25G
      sloppiness = random_seed
      umask = 002
      compiler_check = content
    '')
    |> (conf: {
      nixpkgs.overlays = [
        (_: prev: {
          ccacheWrapper = prev.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_DIR="/nix/var/cache/ccache"
              export CCACHE_CONFIGPATH="''${CCACHE_CONFIGPATH:-${conf}}"
            '';
          };
        })
      ];

      systemd.tmpfiles.rules = [
        "d /nix/var/cache/ccache 2770 root nixbld - -"
        "L+ /nix/var/cache/ccache/ccache.conf - - - - ${conf}"
      ];

      nix.settings.extra-sandbox-paths = [
        "/nix/var/cache/ccache"
        "/nix/var/cache/sccache"
      ];

      programs.ccache = {
        enable = true;
        packageNames = [
          "linux-7w7r-rockchip"
          "linux-7w7r-sunxi-hardened"
          "linux-v7w7r-rockchip-7.1.4-v7w7r-rockchip"
          "linux-v7w7r-sunxi-hardened-7.1.4-v7w7r-sunxi-hardened"
        ];
        cacheDir = "/nix/var/cache/ccache";
      };
    });
}
