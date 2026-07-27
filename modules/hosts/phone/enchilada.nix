{ den, ... }:
{
  #nix build -L ".#nixosConfigurations.phone-enchilada.config.system.build.toplevel"
  #nix build -L ".#nixosConfigurations.phone-enchilada.config.system.build.diskoImagesScript"

  den = {
    hosts.aarch64-linux.phone-enchilada.users.victor7w7r = { };
    aspects.phone-enchilada = {
      includes = with den.aspects; [ phone.common ];

      nixos = {
        networking.hostName = "v7w7r-enchilada";
        hardware.deviceTree.name = "qcom/sdm845-oneplus-enchilada.dtb";
      };
    };
  };
}
