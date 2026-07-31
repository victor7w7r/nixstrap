{
  den,
  hosts,
  inputs,
  kernel,
  ...
}:
{
  den = {
    hosts.x86_64-linux.handheld.users.victor7w7r = { };
    aspects.handheld =
      { user, ... }:
      {
        includes = with den.aspects; [
          (hosts.lib.zram { })
          handheld._

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
          virt
          libvirt
          plasma._
          secrets
          victor7w7r
          waydroid
          xr
        ];

        nixos =
          { lib, pkgs, ... }:
          {
            networking.hostName = "v7w7r-rc71l";
            nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.pinned ];

            boot = {
              extraModprobeConfig = "options kvm-amd nested=1";
              resumeDevice = "/dev/mapper/swapcrypt";
              blacklistedKernelModules = [ "snd_hda_intel" ];
              kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4; # (kernel.hosts.handheld pkgs).handheld-kernelPackages;
              kernelParams = [
                "mitigations=off"
                "nospectre_v1"
                "nospectre_v2"
                "spec_store_bypass_disable=off"
                "amdgpu.sg_display=0"
                "amdgpu.gttsize=8192"
                "amd_iommu=on"
                "amd_pstate=passive"
                #"resume=/dev/mapper/swapcrypt"
              ];
            };

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

            zramSwap = {
              enable = true;
              algorithm = "zstd";
              memoryPercent = 60;
              priority = 100;
            };

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
