{ den, ... }:
{
  #nix build -L ".#nixosConfigurations.fajita.config.system.build.toplevel"
  #nix build -L ".#nixosConfigurations.fajita.config.system.build.tarball"
  #nix build -L ".#nixosConfigurations.fajita.config.mobile.outputs.android.android-bootimg"

  #mount /dev/sde17 /mnt && rm -rf /mnt/* && tar --zstd -xvf efi.tar.zst -C /mnt/ --no-same-owner && umount /dev/sde17
  #export OPTS="noatime,compress_chksum,compress_algorithm=zstd,age_extent_cache,compress_extension=so,inline_xattr,inline_data,inline_dentry,errors=remount-ro,compress_extension=bin,atgc,flush_merge,discard,checkpoint_merge,gc_merge"
  #mount -o $OPTS /dev/sde18 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/

  den = {
    hosts.aarch64-linux.phone-fajita.users.victor7w7r = { };
    aspects.phone-fajita = {
      includes = with den.aspects; [ phone.common ];
      nixos =
        { lib, pkgs, ... }:
        {
          networking.hostName = "v7w7r-fajita";

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
  };
}
