{
  den,
  inputs,
  lib,
  handheld,
  initrd-services,
  kernel,
  ...
}:
{
  imports = [ (inputs.den.namespace "handheld" false) ];

  den = {
    hosts.x86_64-linux.handheld.users.victor7w7r = { };
    aspects.handheld =
      { user, ... }:
      {
        includes = with den.aspects; [
          handheld.disks
          handheld.hardware
          handheld.initrd
          handheld.services
          (initrd-services.lib.zram { })
          audio._
          cli._
          dev.ccache
          dev.zed
          dev.tools
          gui._
          misc._
          pentest._
          zen._

          android
          bluetooth
          kitty
          libvirt
          plasma
          secrets
          secrets
          victor7w7r
          waydroid
          xr
        ];

        nixos =
          { pkgs, ... }:
          {
            networking.hostName = "v7w7r-rc71l";
            hardware.bolt.enable = true;
            environment = {
              persistence."/nix/persist" = {
                directories = lib.mkAfter [
                  "/etc/asusd"
                  "/etc/hhd"
                ];
                users."${user.name}".directories = [ ".config/rog" ];
              };
              systemPackages = with pkgs; [
                amdgpu_top
                asusctl
                bolt
                brightnessctl
                kdePackages.plasma-thunderbolt
                qjoypad
                radeontop
                ryzenadj
                tbtools
                tbtools
                thunderbolt
              ];
            };

            services.lact.enable = true;
            #system.requiredKernelConfig = pkgs.lib.mkForce [ ];

            boot = {
              extraModprobeConfig = "options kvm-amd nested=1";
              resumeDevice = "/dev/mapper/swapcrypt";
              kernelPackages = (kernel.hosts.handheld pkgs).handheld-kernelPackages;
              kernelParams = [ "resume=/dev/mapper/swapcrypt" ];
            };

            zramSwap = {
              enable = true;
              algorithm = "zstd";
              memoryPercent = 60;
              priority = 100;
            };

            swapDevices = [
              {
                device = "/dev/mapper/swapcrypt";
                discardPolicy = "both";
                options = [ "nofail" ];
              }
            ];

            systemd.services.supergfxd.path = with pkgs; [
              kmod
              pciutils
            ];

            programs.rog-control-center = {
              enable = true;
              autoStart = true;
            };
          };

        provides.to-users.homeManager =
          { config, ... }:
          {
            programs.looking-glass-client.enable = true;
            home.file."games".source = config.lib.file.mkOutOfStoreSymlink "/run/media/games";
          };
      };
  };
}
