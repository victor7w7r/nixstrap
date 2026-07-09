{
  den,
  inputs,
  tarball,
  ...
}:
{
  flake-file.inputs.mobile-nixos = {
    url = "github:mobile-nixos/mobile-nixos";
    flake = false;
  };

  den.aspects.phone.common = {
    includes = with den.aspects; [
      (tarball.lib.call { })
      audio._
      cli._
      dev.ccache
      dev.zed
      dev.tools
      gui._
      misc.comm
      misc.fetch
      pentest._
      zen._

      phone.disks
      android
      bluetooth
      kitty
      libvirt
      plasma._
      secrets
      victor7w7r
      waydroid
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        nixpkgs.overlays = [
          (import "${inputs.mobile-nixos}/overlay/overlay.nix")
          (final: prev: {
            libinput = prev.libinput.overrideAttrs (oldAttrs: {
              nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
                final.pkg-config
                final.lua5_4
              ];
              buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ final.lua5_4 ];
            });
          })
        ];

        imports = [
          inputs.disko.nixosModules.disko
        ]
        ++ (import "${inputs.mobile-nixos}/modules/module-list.nix");

        fileSystems = {
          "/nix/persist".neededForBoot = true;
          "/" = lib.mkDefault {
            device = "/dev/zram1";
            fsType = "ext4";
            neededForBoot = true;
            options = [
              "noatime"
              "x-systemd.device-timeout=0"
            ];
          };
        };

        environment.systemPackages = [
          # (pkgs.callPackage ../custom/sdm845-alsa.nix { })
        ];
        services.udev.extraRules = ''
          SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT}=="1", SUBSYSTEMS=="input", ATTRS{name}=="pmi8998_haptics", TAG+="uaccess", ENV{FEEDBACKD_TYPE}="vibra"
        '';

        hardware.enableRedistributableFirmware = true;

        # SUBSYSTEM=="misc", KERNEL=="fastrpc-*", ENV{ACCEL_MOUNT_MATRIX}+="-1, 0, 0; 0, -1, 0; 0, 0, -1"
        mobile.adbd.enable = true;
        mobile.device.identity.manufacturer = "OnePlus";
        /*
          mobile.device.firmware =
          pkgs.callPackage "${inputs'.mobile-nixos}/devices/oneplus-enchilada/firmware"
            { };
        */

        mobile.hardware = {
          soc = "qualcomm-sdm845";
          ram = 8192;
          screen.width = 1080;
        };

        mobile.boot.serialConsole = "ttyMSM0,115200";
        mobile.boot.defaultConsole = "tty0";
        mobile.boot.stage-1 = {
          compression = "xz";
          kernel.modular = true;
          kernel.allowMissingModules = true;
          usb.enable = true;
          #kernel.package = (pkgs.callPackage ../../kernel/sdm845 { inherit kernelData; }).build;
        };
        #stage-1.shell.enable

        mobile.boot.stage-1.kernel.modules = [
          "f2fs"
        ];

        mobile.quirks.audio.alsa-ucm-meld = true;
        mobile.quirks.qualcomm.sdm845-modem.enable = true;

        mobile.kernel.structuredConfig = [
          (
            helpers: with helpers; {
              USB_F_FS = yes;
              SYSFS = yes;
              RAMFS = yes;
              TMPFS = yes;
              DEVPTS_FS = yes;
              PROC_FS = yes;
              DEVTMPFS = yes;
              CRYPTO_CRC32C = yes;
              USB_CONFIGFS = yes;
              USB_CONFIGFS_F_FS = yes;
            }
          )
        ];

        mobile.boot.stage-1.firmware = [
          (pkgs.runCommand "initrd-firmware" { } ''
            cp -vrf ${config.mobile.device.firmware} $out
            chmod -R +w $out
            find $out/lib/firmware/qcom/sdm845 -name "modem.mbn" -delete -print
            cp -vf ${pkgs.linux-firmware}/lib/firmware/qcom/{a630_sqe.fw,a630_gmu.bin} $out/lib/firmware/qcom
          '')
        ];

        mobile.usb.mode = "gadgetfs";
        mobile.usb.idVendor = lib.mkDefault "18D1";
        mobile.usb.idProduct = lib.mkDefault "D001";
        mobile.usb.gadgetfs.functions = {
          adb = "ffs.adb";
          mass_storage = "mass_storage.0";
          rndis = "rndis.usb0";
        };

        mobile.system.type = "android";
        mobile.system.android = {
          ab_partitions = lib.mkDefault true;
          bootimg.flash = {
            offset_base = "0x00000000";
            offset_kernel = "0x00008000";
            offset_ramdisk = "0x01000000";
            offset_second = "0x00000000";
            offset_tags = "0x00000100";
            pagesize = "4096";
          };
          appendDTB = lib.mkDefault [
            "dtbs/qcom/sdm845-${config.mobile.device.name}.dtb"
          ];
        };

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = 60;
          priority = 100;
        };

      };
  };
}

/*
    blacklistedKernelModules = [
        "qcrypto"
        "ipa"
      ];
      kernelParams = [
        "clk_ignore_unused"
        "pd_ignore_unused"
        "arm64.nopauth"
        "console=ttyGS0,115200"
        "console=tty0"

        "rd.systemd.default_standard_output=kmsg+console"
        "rd.systemd.default_standard_error=kmsg+console"
        "rd.systemd.journald.forward_to_console=1"
        "rd.systemd.log_target=console"
        "rd.systemd.journald.forward_to_console=1"
      ];
      initrd = {
        includeDefaultModules = false;
        systemd = {
          tpm2.enable = false;
          extraBin.buffyboard = "${(pkgs.callPackage ./custom/buffybox.nix { })}/bin/buffyboard";
          contents."/share".source = "${pkgs.libinput.out}/share";
          storePaths = [ pkgs.libinput ];
        };
        kernelModules = [
          "qcom_pd_mapper"
          "sd_mod"
          "scsi_mod"
          "dm_mod"
          "ufshcd-core"
          "ufs-qcom"
          "phy-qcom-qmp-ufs"
        ];
      };
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "firmware-oneplus-sdm845"
        "firmware-oneplus-sdm845-xz"
      ];
    hardware.firmware = lib.mkAfter [ (pkgs.callPackage ../custom/oneplus.nix { }) ];

    systemd.services.ModemManager.serviceConfig.ExecStart = [
    "${pkgs.modemmanager}/bin/ModemManager --test-quick-suspend-resume"
    ];
*/
