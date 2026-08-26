{
  den.aspects.phosh = {
    nixos =
      { pkgs, self', ... }:
      {
        users.users."victor7w7r" = {
           isNormalUser = true;
           initialPassword = "147258";
           extraGroups = [
             "feedbackd"
           ];
         };

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

    provides.to-users.homeManager = {

    };
  };
}
