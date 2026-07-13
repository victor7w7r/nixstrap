{
  den,
  inputs,
  withSystem,
  kernel,
  ...
}:
{
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
            main-kernel = (kernel.hosts.main pkgs).main-kernel;
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
