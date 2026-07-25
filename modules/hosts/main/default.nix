{ den, kernel, ... }:
{
  den = {
    hosts.x86_64-linux = {
      main-chroot.users.victor7w7r = { };
      main.users.victor7w7r = { };
    };

    aspects.main = {
      includes = with den.aspects; [
        main._

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
        gestures
        kitty
        libvirt
        plasma._
        secrets
        victor7w7r
        waydroid
        xr
      ];
      nixos =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        {
          networking = {
            hostName = "v7w7r-macmini81";
            networkmanager = {
              unmanaged = [ "enp2s0f1u1" ];
              ensureProfiles.profiles."static-network" = {
                connection = {
                  id = "static-network";
                  type = "ethernet";
                  interface-name = "enp4s0";
                  autoconnect = true;
                };
                ipv4 = {
                  method = "manual";
                  address1 = "192.168.100.6/24,192.168.100.1";
                  dns = "1.1.1.1;8.8.8.8;";
                };
                ipv6.method = "disabled";
              };
            };
          };
          boot = {
            kernelPackages = (kernel.hosts.main pkgs).main-kernelPackages;
            kernelParams = [ "kvmfr.static_size_mb=128" ];
            resumeDevice = "/dev/mapper/swapcrypt";
            extraModulePackages = [ self'.packages.apple-bce ];
            extraModprobeConfig = ''
              options kvm-intel nested=1
              options kvm_intel emulate_invalid_guest_state=0
            '';
          };

          virtualisation.kvmgt.enable = true;
          environment.systemPackages = with pkgs; [
            bolt
            picocom
            tbtools
            thunderbolt
            rkdeveloptool
            sunxi-tools
            kdePackages.plasma-thunderbolt
            (wineWow64Packages.unstableFull.overrideAttrs (prev: {
              src = fetchurl {
                url = "https://dl.winehq.org/wine/source/9.x/wine-9.22.tar.xz";
                hash = "sha256-4VDSl0KqVPdo7z6XbthhqqT59IVC5Am+qQLQ9Js1loM=";
              };
              preConfigure = ''
                export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -std=gnu17"
              '';
              version = "9.22";
            }))
            winetricks
          ];

          services.thermald.enable = true;
          hardware = {
            cpu.intel.updateMicrocode = true;
            firmware = lib.mkAfter [ self'.packages.brcm-firmware ];
          };

          systemd.tmpfiles.rules = [
            "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 1"
            "w /sys/devices/system/cpu/intel_pstate/max_perf_pct - - - - 80"
            "w /sys/block/bcache0/bcache/cache_mode - - - - writeback"
          ];
        };

      provides.to-users.homeManager =
        { config, ... }:
        {
          programs.looking-glass-client.enable = true;
          home.file = {
            "shared".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shared";
            "storage".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/storage";
          };
        };
    };
  };
}
