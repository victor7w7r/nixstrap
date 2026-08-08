{ den, inputs, ... }:
{
  #mount /dev/sde17 /mnt && rm -rf /mnt/* && tar --zstd -xvf efi.tar.zst -C /mnt/ --no-same-owner && umount /dev/sde17
  #export OPTS="noatime,compress_chksum,compress_algorithm=zstd,age_extent_cache,compress_extension=so,inline_xattr,inline_data,inline_dentry,errors=remount-ro,compress_extension=bin,atgc,flush_merge,discard,checkpoint_merge,gc_merge"
  #mount -o $OPTS /dev/sde18 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/

  perSystem.packages = {
    phone-fajita-toplevel = inputs.self.nixosConfigurations.phone-fajita.config.system.build.toplevel;

    phone-fajita-script =
      inputs.self.nixosConfigurations.phone-fajita.config.system.build.diskoImagesScript;
  };

  den = {
    hosts.aarch64-linux.phone-fajita.users.victor7w7r = { };
    aspects.phone-fajita = {
      includes = with den.aspects; [ phone.common ];
      nixos =
        { lib, pkgs, ... }:
        {
          networking.hostName = "v7w7r-fajita";
          hardware.deviceTree.name = "qcom/sdm845-oneplus-fajita.dtb";
        };
    };
  };
}
