{
  crane,
  den,
  inputs,
  withSystem,
  tauchgang,
  kernel,
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
          inputs.cachyos-kernel.overlays.pinned
          (final: _: {
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
