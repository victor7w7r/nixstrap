{
  flavor,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    useUserPackages = true;
    useGlobalPkgs = true;

    users.nixstrap = {
      home = {
        username = "nixstrap";
        homeDirectory = "/home/nixstrap";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;

      home.packages = (
        with pkgs;
        [
          clolcat
          fortune
        ]
      );

      services.network-manager-applet.enable = true;

      imports = [
        (import ./config.nix)
        (import ./starship.nix)
      ]
      ++ (
        if (flavor == "graphical") then
          [
            (import ./desktop.nix)
            (import ./packages.nix)
          ]
        else
          [ ]
      );
    };
  };
}
