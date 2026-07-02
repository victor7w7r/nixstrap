{ den, kernel, ... }:
{
  den = {
    hosts.x86_64-linux.generic.users.snowflake = { };
    #nix build -L ".#nixosConfigurations.generic.config.system.build.toplevel"
    aspects.generic = {
      includes = with den.aspects; [
        generic._

        cli._
        dev.mise
        gui._
        misc.comm
        misc.fetch
        zen._

        kitty
        plasma
        secrets
      ];

      nixos =
        { pkgs, modulesPath, ... }:
        {
          networking.hostName = "v7w7r-generic";
          virtualisation.vmVariant.virtualisation.useEFIBoot = true;
          imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

          boot = {
            kernelParams = [
              "intel_pstate=disable"
              "i915.enable_guc=2"
              "i915.enable_psr=0"
            ];
            kernelPackages = (kernel.hosts.generic pkgs).generic-kernelPackages;
            initrd = {
              availableKernelModules = [
                "ahci"
                "xhci_pci"
                "sr_mod"
              ];
            };
          };
        };
    };
  };
}
