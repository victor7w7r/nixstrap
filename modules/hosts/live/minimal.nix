{ den, inputs, ... }:
{
  perSystem.packages = {
    minimal-live-toplevel = inputs.self.nixosConfigurations.minimal-live.config.system.build.toplevel;
    minimal-live-image = inputs.self.nixosConfigurations.minimal-live.config.system.build.isoImage;
  };

  den = {
    hosts.x86_64-linux.minimal-live.users.snowflake = { };
    aspects.minimal-live = {
      includes = with den.aspects; [
        live.common
        snowflake
      ];
      nixos =
        { lib, ... }:
        {
          isoImage.edition = lib.mkOverride 500 "minimal";
          fonts.fontconfig.enable = lib.mkOverride 500 false;
          system.nixos.variant_id = lib.mkDefault "minimal";

          xdg = with lib; {
            autostart.enable = mkDefault false;
            icons.enable = mkDefault false;
            mime.enable = mkDefault false;
            sounds.enable = mkDefault false;
          };
        };
    };
  };
}
