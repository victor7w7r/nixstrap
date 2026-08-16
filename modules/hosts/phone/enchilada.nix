{ den, inputs, ... }:
{
  perSystem.packages = {
    phone-enchilada-toplevel =
      inputs.self.nixosConfigurations.phone-enchilada.config.system.build.toplevel;

    phone-enchilada-script =
      inputs.self.nixosConfigurations.phone-enchilada.config.system.build.diskoImagesScript;
  };

  den = {
    hosts.aarch64-linux.phone-enchilada.users = {
      snowflake = { };
      root = { };
    };
    aspects.phone-enchilada = {
      includes = with den.aspects; [ phone.common ];

      nixos = {
        networking.hostName = "v7w7r-enchilada";
        hardware.deviceTree.name = "qcom/sdm845-oneplus-enchilada.dtb";
      };
    };
  };
}
