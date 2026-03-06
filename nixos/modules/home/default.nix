{
  inputs,
  username,
  host,
  pkgs,
  system,
  self,
  ...
}:
let
  homeConfig =
    {
      user ? "root",
    }:
    {
      programs.home-manager.enable = true;
      home = {
        username = user;
        homeDirectory = "/home/${user}";
        stateVersion = "25.11";
      };

      imports = [
        (import ./desktop)
        (import ./dev)
        (import ./hardware)
        (import ./networking)
        (import ./system)
        (import ./zen)
      ]
      ++ (
        if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") then
          [
            (import ./misc)
            (import ./multimedia)
          ]
        else
          [ ]
      );
    };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        system
        self
        ;
    };
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.zen-browser.homeModules.twilight
      inputs.nix-doom-emacs-unstraightened.homeModule
    ];
    users = {
      ${username} = homeConfig { inherit username; };
      root = homeConfig { };
    };
  };
}
