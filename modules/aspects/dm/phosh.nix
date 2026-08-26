{
  den.aspects.phosh = {
    nixos =
      { pkgs, ... }:
      {
        services.xserver.desktopManager.phosh = {
          enable = true;
          user = "victor7w7r";
          group = "users";
        };

        environment.systemPackages = [
          pkgs.alacritty
          pkgs.phosh-mobile-settings
        ];
      };
  };
}
