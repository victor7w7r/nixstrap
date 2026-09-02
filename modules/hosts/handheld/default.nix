{
  den,
  hosts,
  inputs,
  kernel,
  ...
}:
{
  perSystem.packages.handheld-toplevel =
    inputs.self.nixosConfigurations.handheld.config.system.build.toplevel;

  den = {
    hosts.x86_64-linux.handheld.users = {
      #root = { };
      victor7w7r = { };
    };

    aspects.handheld =
      { user, ... }:
      {
        includes = with den.aspects; [
          (hosts.lib.zram {
            value = "8G";
            memoryPercent = 100;
          })
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
          disks
          emulation
          firewall
          games
          kitty
          libvirt
          remote
          root
          plasma._
          secrets
          victor7w7r
          virt
          tools
          waydroid
          xr
        ];

        nixos =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            networking.hostName = "v7w7r-rc71l";
            boot = {
              kernelPackages =
                (kernel.hosts.handheld pkgs "handheld" "x86_64-linux" pkgs.stdenv.hostPlatform.system)
                .handheld-kernelPackages;
              extraModprobeConfig = "options kvm-amd nested=1";
              kernelParams = [
                "mitigations=off"
                "nospectre_v1"
                "nospectre_v2"
                "spec_store_bypass_disable=off"
                "amdgpu.sg_display=0"
                "amd_iommu=on"
                "amd_pstate=passive"
                "resume=${config.boot.resumeDevice}"
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

            programs.rog-control-center = {
              enable = true;
              #autoStart = true;
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
