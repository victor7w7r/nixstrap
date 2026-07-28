{
  den,
  hosts,
  inputs,
  kernel,
  ...
}:
{
  flake-file.inputs.nixpkgs-wine.url = "github:NixOS/nixpkgs/a1945f760a8fe019a4d753808de424dcd4e5b3cf";

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
        {
          lib,
          pkgs,
          inputs',
          self',
          ...
        }:
        {
          imports = [ inputs.disko.nixosModules.disko ];
          #nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

          networking = {
            hostName = "v7w7r-macmini81";
            networkmanager.unmanaged = [ "enp2s0f1u1" ];
          };
          boot = {
            kernelPackages = pkgs.cachyosKernels.linux-cachyos-latest-lto; # (kernel.hosts.main pkgs).main-kernelPackages;
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

          services.thermald.enable = true;

          hardware = {
            graphics = {
              enable32Bit = true;
              extraPackages = with pkgs; [
                intel-media-driver
                vulkan-loader
                vulkan-validation-layers
                vulkan-extension-layer
              ];
              extraPackages32 = with pkgs.pkgsi686Linux; [
                intel-media-driver
                vulkan-loader
              ];
            };
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
