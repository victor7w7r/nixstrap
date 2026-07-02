{ den, lib, ... }:
{
  den.aspects.live.common = {
    includes = with den.aspects; [
      (den.batteries.tty-autologin "snowflake")
      cli._
      secrets
      snowflake
    ];

    nixos =
      {
        config,
        modulesPath,
        pkgs,
        ...
      }:
      {
        imports = [
          "${modulesPath}/profiles/base.nix"
          "${modulesPath}/profiles/clone-config.nix"
          "${modulesPath}/profiles/qemu-guest.nix"
          "${modulesPath}/installer/cd-dvd/iso-image.nix"
          "${modulesPath}/installer/cd-dvd/channel.nix"
        ];

        environment = {
          networking.hostName = "v7w7r-live";
          defaultPackages =
            with pkgs;
            lib.mkDefault [
              mdadm
              lm_sensors
              lshw
              nix-du
              smartmontools
            ];
          variables.GC_INITIAL_HEAP_SIZE = "1M";
          stub-ld.enable = false;
          etc."systemd/pstore.conf".text = ''
            [PStore]
            Unlink=no
          '';
        };

        system = {
          extraDependencies =
            with pkgs;
            lib.mkForce [
              stdenvNoCC
              jq
              busybox
              makeInitrdNGTool
            ];
          stateVersion = "26.05";
        };

        hardware.cpu = {
          amd.updateMicrocode = true;
          intel.updateMicrocode = true;
        };

        image.fileName = "snowflake-${config.system.nixos.label}.iso";
        swapDevices = lib.mkImageMediaOverride [ ];
        fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

        services = {
          getty.autologinUser = "snowflake";
          openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
          };
          timesyncd.enable = true;
        };

        isoImage = {
          #configurationName = flavor;
          makeEfiBootable = true;
          makeUsbBootable = true;
          squashfsCompression = "xz -Xbcj x86 -Xdict-size 100% -b 512K -limit 75 -percentage";
        };

        networking.wireless.enable = lib.mkImageMediaOverride true;

        documentation = with lib; {
          man.man-db.enable = mkDefault false;
          enable = mkDefault false;
          doc.enable = mkDefault false;
          info.enable = mkDefault false;
          man.enable = mkDefault false;
          nixos.enable = mkDefault false;
        };

        virtualisation = {
          vmware.guest.enable = true;
          virtualbox.guest.enable = false;
        };

        boot = {
          swraid = {
            enable = true;
            mdadmConf = "MAILADDR root";
          };
          postBootCommands = ''
            for o in $(</proc/cmdline); do
              case "$o" in
                live.nixos.passwd=*)
                  set -- $(IFS==; echo $o)
                  echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
                  ;;
              esac
            done
          '';
          kernel.sysctl."vm.overcommit_memory" = "1";
          kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;
          initrd = {
            availableKernelModules = [
              "dm-thin-pool"
              "dm-snapshot"
              "md_mod"
              "raid456"
              "bcache"
            ];
            services.lvm.enable = true;
          };
          kernelParams = [
            "add_efi_memmap"
            "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
            "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
            "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
          ];
          supportedFilesystems = lib.mkForce [
            "btrfs"
            "xfs"
            "bcachefs"
            "ext4"
            "exfat"
            "f2fs"
            "ntfs"
            "vfat"
          ];
        };
      };
  };
}
