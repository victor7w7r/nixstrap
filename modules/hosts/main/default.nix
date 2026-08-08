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
      main.users.victor7w7r = { };
    };

    aspects.main = {
      includes = with den.aspects; [
        (hosts.lib.static-network "enp4s0" "6")
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
        virt
        libvirt
        plasma._
        secrets
        victor7w7r
        waydroid
        xr
      ];
      nixos =
        { pkgs, inputs', ... }:
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
            kernelPackages = (kernel.hosts.main pkgs false).main-kernelPackages;
            kernelParams = [
              "video=DP-3:1600x900@60e"
              "kvmfr.static_size_mb=128"
              "iommu=pt"
              "i915.enable_guc=2"
              "kvm_intel.nested=1"
              "intel_pstate=passive"
              "intel_iommu=on"
              "pcie_ports=native"
              #"libahci.ignore_sss=1"
              #"ahci.mobile_lpm_policy=2"
              "drm.polled=14"
            ];
            extraModprobeConfig = ''
              options kvm-intel nested=1
              options kvm_intel emulate_invalid_guest_state=0
            '';
            resumeDevice = "/dev/mapper/swapcrypt";
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
