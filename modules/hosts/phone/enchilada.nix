{ den, ... }:
{
  #nix build -L ".#nixosConfigurations.enchilada.config.system.build.toplevel"
  #nix build -L ".#nixosConfigurations.enchilada.config.system.build.tarball"
  #nix build -L ".#nixosConfigurations.enchilada.config.mobile.outputs.android.android-bootimg"

  den = {
    hosts.aarch64-linux.phone-enchilada.users.victor7w7r = { };
    aspects.phone-enchilada = {
      includes = with den.aspects; [ phone.common ];

      nixos =
        { lib, pkgs, ... }:
        {
          networking.hostName = "v7w7r-enchilada";

          mobile = {
            system.android.device_name = "OnePlus6";
            generatedFilesystems.rootfs = lib.mkDefault {
              filesystem = lib.mkForce "btrfs";
              extraPadding = lib.mkForce (pkgs.image-builder.helpers.size.MiB 128);
            };
            device = {
              name = "oneplus-enchilada";
              supportLevel = "supported";
              identity.name = "OnePlus 6";
            };
            hardware.screen.height = 2280;
          };
        };
    };
  };
}
