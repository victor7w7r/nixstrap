{ lib, ... }:
{
  den.default.nixos =
    {
      isIntel,
      isLive,
      isGeneric,
      hasVisualKeyboard,
      ...
    }:
    {
      boot = {
        supportedFilesystems = [
          "btrfs"
          "ext4"
          "exfat"
          "f2fs"
          "ntfs"
          "vfat"
        ]
        ++ lib.optionals isIntel [ "xfs" ]
        ++ lib.optionals (isLive || hasVisualKeyboard || isGeneric) [ "bcachefs" ];

        consoleLogLevel = 4;
        modprobeConfig.enable = true;
        kernelParams = [ "lsm=landlock,yama,integrity,apparmor,bpf" ];
        tmp = {
          cleanOnBoot = true;
          useTmpfs = true;
        };
        extraModprobeConfig = ''
          blacklist iTCO_wdt
          blacklist joydev
          blacklist mousedev
          blacklist mac_hid
          blacklist intel_hid
        '';
        initrd = {
          /*
            availableKernelModules = [
              "autofs"
              "dm-thin-pool"
              "dm-snapshot"
              "tpm_tis"
              "tpm_crb"
            ];
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
              }
          */

          checkJournalingFS = true;
          services.lvm.enable = true;
          compressorArgs = [
            "-19"
            "--ultra"
            "-T0"
            "--check"
          ];
          network.enable = true;
          verbose = true;
        };
      };
    };
}
