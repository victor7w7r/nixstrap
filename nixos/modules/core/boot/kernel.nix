{ pkgs, ... }:
let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "exfat"
    "f2fs"
    "ntfs"
    "vfat"
  ];
in
{
  /*
    specialisation = with lib; {
    zen-mode.configuration.boot.kernelPackages = mkForce pkgs.linuxPackages_zen;
    lqx.configuration.boot.kernelPackages = mkForce pkgs.linuxPackages_lqx;
    lts.configuration.boot.kernelPackages = mkForce pkgs.linuxPackages_6_12;
    secure.configuration.boot.kernelPackages = mkForce pkgs.linuxPackages_hardened;
    };
  */

  boot = {
    consoleLogLevel = 4;
    modprobeConfig.enable = true;
    inherit supportedFilesystems;
    #kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.efiSysMountPoint = "/boot/EFI";
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot.enable = false;
    };

    initrd = {
      checkJournalingFS = true;
      availableKernelModules = [
        "dm-thin-pool"
        "dm-snapshot"
      ];
      compressorArgs = [
        "-19"
        "--ultra"
        "-T0"
        "--progress"
        "--check"
      ];
      network.enable = true;
      inherit supportedFilesystems;
      services.lvm.enable = true;
      verbose = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
        users.root.shell = "${pkgs.bashInteractive}/bin/bash";
        storePaths = [ "${pkgs.bashInteractive}/bin/bash" ];
        extraBin = {
          ip = "${pkgs.iproute2}/bin/ip";
          ping = "${pkgs.iputils}/bin/ping";
          cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
        };
      };
    };
    kernelModules = [
      "tcp_bbr"
      "dm-thin-pool"
      "veth"
      "xt_comment"
      "xt_CHECKSUM"
      "xt_MASQUERADE"
      "vhost_vsock"
      "iptable_mangle"
    ];
    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist joydev
      blacklist mousedev
      blacklist mac_hid
      blacklist intel_hid

      options kvm-amd nested=1
      options kvm-intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 70;
  };

}
