{ ... }:
{
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.victor7w7r = {
      programs.home-manager.enable = true;
      home.stateVersion = "24.05";
      imports = [
        (import ./config.nix)
        (import ./kitty.nix)
        (import ./starship.nix)
      ];
    };
  };
}
