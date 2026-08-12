{ inputs, ... }:
{
  #nix run ".#vmGeneric"
  perSystem =
    { config, pkgs, ... }:
    {
      packages = {
        vmGeneric = pkgs.writeShellApplication {
          name = "generic-vm";
          text =
            inputs.self.nixosConfigurations.generic.config
            |> (host: ''
              ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
            '');
        };
      };

      apps = {
        vmGeneric = {
          type = "app";
          program = "${config.packages.vmGeneric}/bin/generic-vm";
        };

        vmHandheld = {
          type = "app";
          program = "${config.packages.vmHandheld}/bin/handheld-vm";
        };
      };
    };
}
