{
  rustCall,
  den,
  inputs,
  withSystem,
  self,
  ...
}:
{
  flake-file.inputs.pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem =
    { pkgs, system, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
      pkgsDirectory = ../../pkgs/by-name;
      pkgsNameSeparator = "-";
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = false;
        };
        overlays = [
          (final: _: {
            inherit self;
            cache-stdenv = pkgs.overrideCC pkgs.stdenv (
              pkgs.ccacheWrapper.override {
                cc = pkgs.stdenv.cc;
                extraConfig = ''
                  export CCACHE_COMPRESS=1
                  export CCACHE_DIR="/var/cache/ccache"
                  export CCACHE_UMASK="007"
                  export CCACHE_SLOPPINESS=random_seed
                  export CCACHE_READ_ONLY_FALLBACK=true
                '';
              }
            );
            rustBuild = rustCall;
          })
        ];
      };
    };

  flake.overlays.default =
    _: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        local = config.packages;
      }
    );
}
