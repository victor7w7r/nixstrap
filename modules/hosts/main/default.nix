{
  den,
  hosts,
  inputs,
  kernel,
  ...
}:
{
  flake-file.inputs.nixpkgs-wine.url = "github:NixOS/nixpkgs/a1945f760a8fe019a4d753808de424dcd4e5b3cf";

  perSystem.packages.main-toplevel =
    inputs.self.nixosConfigurations.main.config.system.build.toplevel;

  den = {
    hosts.x86_64-linux = {
      main-chroot.users.victor7w7r = { };
      main.users = {
        #root = { };
        victor7w7r = { };
      };
    };

    aspects.main = {
      includes = with den.aspects; [
        (hosts.lib.static-network "enp4s0" "6")
        (hosts.lib.zram {
          value = "32G";
          memoryPercent = 25;
        })
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
        disks
        emulation
        firewall
        games
        gestures
        kitty
        libvirt
        plasma._
        remote
        root
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
          pkgs,
          inputs',
          ...
        }:
        {
          networking = {
            hostName = "v7w7r-macmini81";
            networkmanager.unmanaged = [ "enp2s0f1u1" ];
          };

          virtualisation = {
            kvmgt.enable = true;
            incus.ui.enable = true;
          };

          systemd.tmpfiles.rules = [
            "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 1"
            "w /sys/devices/system/cpu/intel_pstate/max_perf_pct - - - - 80"
            "w /sys/block/bcache0/bcache/cache_mode - - - - writeback"
          ];

          boot = {
            kernelPackages =
              (kernel.hosts.main pkgs "main" "x86_64-linux" pkgs.stdenv.hostPlatform.system).main-kernelPackages;
            kernelParams = [
              "ahci.mobile_lpm_policy=2"
              "intel_iommu=on"
              "intel_pstate=passive"
              "iommu=pt"
              "kvmfr.static_size_mb=128"
              "coherent_pool=64M"
              "cma=256M"
              "swiotlb=64M"
              "libahci.ignore_sss=1"
              "pcie_ports=compat"
              "video=DP-3:1600x900@60e"
              "resume=${config.boot.resumeDevice}"
              #"i915.enable_guc=2"
            ];
            extraModprobeConfig = ''
              options kvm-intel nested=1
              options kvm_intel emulate_invalid_guest_state=0
            '';
          };

          environment.systemPackages = with pkgs; [
            bolt
            picocom
            tbtools
            nbd
            thunderbolt
            rkdeveloptool
            sunxi-tools
            kdePackages.plasma-thunderbolt
            inputs'.nixpkgs-wine.legacyPackages.wineWow64Packages.staging
            freetype
            gnutls
            libxcrypt
            winetricks

            pkgsi686Linux.glibc
            pkgsi686Linux.stdenv.cc.cc.lib
            pkgsi686Linux.gnutls
            pkgsi686Linux.freetype
            pkgsi686Linux.libxcrypt
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
