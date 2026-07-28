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
            imports = [ inputs.disko.nixosModules.disko ];
            boot = {
              extraModprobeConfig = "options kvm-amd nested=1";
              resumeDevice = "/dev/mapper/swapcrypt";
              blacklistedKernelModules = [ "snd_hda_intel" ];
              kernelPackages = (kernel.hosts.handheld pkgs).handheld-kernelPackages;
              #kernelParams = [ "resume=/dev/mapper/swapcrypt" ];
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
