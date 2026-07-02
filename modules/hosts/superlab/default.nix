{
  den,
  inputs,
  initrd-services,
  superlab,
  kernel,
  ...
}:
{
  imports = [ (inputs.den.namespace "superlab" false) ];

  den = {
    hosts.aarch64-linux.superlab.users.victor7w7r = { };

    aspects.superlab = {
      includes = with den.aspects; [
        (initrd-services.lib.zram { })
        superlab.disks

        audio._
        cli._
        dev._
        gui._
        misc.comm
        misc.fetch
        pentest._
        zen._

        android
        bluetooth
        cockpit
        kitty
        libvirt
        plasma
        secrets
        victor7w7r
        waydroid
        xr
      ];

      nixos =
        { pkgs, ... }:
        {
          networking.hostName = "v7w7r-radxarock5b";
          boot = {
            kernelParams = [
              "console=ttyS2,1500000n8"
            ];
            loader = {
              grub.enable = false;
              generic-extlinux-compatible.enable = true;
            };
            kernelPackages = (kernel.hosts.superlab pkgs).superlab-kernelPackages;
            #pkgs.ubootRock5ModelB;
            # kernelPackages = kernel.packages;
          };

          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 20;
            priority = 100;
          };
        };
    };
  };
}
