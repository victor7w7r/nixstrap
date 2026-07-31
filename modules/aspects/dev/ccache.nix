{
  den.aspects.dev.ccache.nixos = { config, ... }: {
    nixpkgs.overlays = [
      (_: prev: {
        ccacheWrapper = prev.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS=1
            export CCACHE_DIR="${config.programs.ccache.cacheDir}"
            export CCACHE_UMASK="007"
            export CCACHE_SLOPPINESS=random_seed
            export CCACHE_PREFIX="${prev.strace}/bin/strace -e trace=file,process -o /tmp/ccache_strace.log"
          '';
        };
      })
    ];

    systemd.tmpfiles.rules = [
      "d ${config.programs.ccache.cacheDir}                        770 root    nixbld  - -"
    ];
    nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
    programs.ccache.enable = true;
  };
}
