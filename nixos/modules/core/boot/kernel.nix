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
    secure.configuration.boot.kernelPackages = mkForce pkgs.linuxPackages_hardened;
    };
  */

  boot = {
    consoleLogLevel = 4;
    modprobeConfig.enable = true;
    inherit supportedFilesystems;
    loader = {
      efi.efiSysMountPoint = "/boot/EFI";
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot.enable = false;
    };

    initrd = {
      checkJournalingFS = true;
      availableKernelModules = [
        "autofs"
        "dm-thin-pool"
        "dm-snapshot"
        "tpm_tis"
        "tpm_crb"
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
        initrdBin = [ pkgs.coreutils ];
        storePaths = [ "${pkgs.bashInteractive}/bin/bash" ];
        settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
          DefaultTimeoutAbortSec = "5s";
          DefaultLimitNOFILE = "2048:2097152";
        };
        extraBin = {
          ip = "${pkgs.iproute2}/bin/ip";
          ping = "${pkgs.iputils}/bin/ping";
          cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
          busybox = "${pkgs.busybox-sandbox-shell}/bin/busybox";
          find = "${pkgs.findutils}/bin/find";
          fdisk = "${pkgs.util-linux}/bin/fdisk";
          lsblk = "${pkgs.util-linux}/bin/lsblk";
          lspci = "${pkgs.pciutils}/bin/lspci";
          grep = "${pkgs.gnugrep}/bin/grep";
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
