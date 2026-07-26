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
        };
    };
  };
}
