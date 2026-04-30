{
  pkgs,
  system,
  ...
}:
let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "exfat"
    "f2fs"
    "ntfs"
    "xfs"
    "vfat"
  ];
in
{
  boot = {
    consoleLogLevel = 4;
    modprobeConfig.enable = true;
    inherit supportedFilesystems;
    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
    }
    // (
      if system == "x86_64-linux" then
        {
          efi = {
            efiSysMountPoint = "/boot/EFI";
            canTouchEfiVariables = true;
          };
        }
      else
        { }
    );

    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

  }
  // (
    if system == "x86_64-linux" then
      {
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
            contents = {
              "/etc/ssl/certs/ca-certificates.crt".source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
              #"/etc/terminfo".source = "${pkgs.ncurses}/share/terminfo";
            };
            initrdBin = [ pkgs.coreutils ];
            storePaths = [
              "${pkgs.bashInteractive}/bin/bash"
              pkgs.util-linux
              pkgs.ncurses
            ];
            settings.Manager = {
              DefaultTimeoutStartSec = "15s";
              DefaultTimeoutStopSec = "10s";
              DefaultTimeoutAbortSec = "5s";
              DefaultLimitNOFILE = "2048:2097152";
            };
            extraBin = {
              nix = "${pkgs.nix}/bin/nix";
              ip = "${pkgs.iproute2}/bin/ip";
              curl = "${pkgs.curl}/bin/curl";
              ping = "${pkgs.iputils}/bin/ping";
              cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
              busybox = "${pkgs.busybox-sandbox-shell}/bin/busybox";
              htop = "${pkgs.htop}/bin/htop";
              yazi = "${pkgs.yazi-unwrapped}/bin/yazi";
              find = "${pkgs.findutils}/bin/find";
              fdisk = "${pkgs.util-linux}/bin/fdisk";
              file = "${pkgs.file}/bin/file";
              blkid = "${pkgs.util-linux}/bin/blkid";
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
      }
    else
      { }
  );

}
