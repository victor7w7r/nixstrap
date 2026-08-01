{
  crane,
  den,
  inputs,
  withSystem,
  tauchgang,
  kernel,
  self,
  ...
}:
{

  flake-file.inputs.crane.url = "github:ipetkov/crane";

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
          #inputs.cachyos-kernel.overlays.pinned
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
                '';
              }
            );
            main-kernel = pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v3; # (kernel.hosts.main pkgs).main-kernel;
            tauchgang = tauchgang.lib.call;
            crane = crane.lib.call;
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
