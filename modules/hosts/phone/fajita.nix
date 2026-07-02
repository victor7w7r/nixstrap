#nix build -L ".#nixosConfigurations.fajita.config.system.build.toplevel"
#nix build -L ".#nixosConfigurations.fajita.config.system.build.tarball"
#nix build -L ".#nixosConfigurations.fajita.config.mobile.outputs.android.android-bootimg"
#mount /dev/sde17 /mnt && rm -rf /mnt/* && tar --zstd -xvf efi.tar.zst -C /mnt/ --no-same-owner && umount /dev/sde17
#export OPTS="noatime,compress_chksum,compress_algorithm=zstd,age_extent_cache,compress_extension=so,inline_xattr,inline_data,inline_dentry,errors=remount-ro,compress_extension=bin,atgc,flush_merge,discard,checkpoint_merge,gc_merge"
#mount -o $OPTS /dev/sde18 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/

#(import "${inputs.mobile-nixos}/modules/module-list.nix");
{ den, lib, ... }:
{
  den = {
    hosts.aarch64-linux.phone-fajita.users.victor7w7r = { };
    aspects.phone-fajita = {
      includes = with den.aspects; [ phone.common ];

      nixos =
        { pkgs, ... }:
        {
          networking.hostName = "v7w7r-fajita";
          nixpkgs.overlays = [
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

          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 60;
            priority = 100;
          };

          #boot.kernelPackages = kernel.packages;

          mobile = {
            system.android.device_name = "OnePlus6T";
            generatedFilesystems.rootfs = lib.mkDefault {
              filesystem = lib.mkForce "btrfs";
              extraPadding = lib.mkForce (pkgs.image-builder.helpers.size.MiB 128);
            };
            device = {
              name = "oneplus-fajita";
              supportLevel = "best-effort";
              identity.name = "OnePlus 6T";
            };
            hardware.screen.height = 2340;
          };
        };
    };

    /*
      fileSystems = {
        "/" = {
          device = "none";
          fsType = "tmpfs";
          options = [
            "defaults"
            "size=2G"
            "mode=755"
          ];
        };
        "/nix" = f2fs {
          label = "NIXOS_SYSTEM";
          device = "/dev/disk/by-label/NIXOS_SYSTEM";
        };
      };

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
    */
  };
}
