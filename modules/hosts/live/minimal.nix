{
  den,
  lib,
  live,
  ...
}:
{
  den = {
    hosts.x86_64-linux.minimal-live.users.snowflake = { };

    aspects.minimal-live = {
      includes = with den.aspects; [
        live.common
        (den.batteries.tty-autologin "snowflake")
        cli._

        secrets
        snowflake
      ];
      nixos = {
        networking.hostName = "v7w7r-live";
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
