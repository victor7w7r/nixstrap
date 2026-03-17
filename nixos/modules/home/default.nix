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
        homeDirectory = if user == "root" then "/root" else "/home/${user}";
        stateVersion = "25.11";
      };

      imports = [
        (import ./system)
      ]
      ++ (
        if (user != "root") then
          [
            (import ./desktop)
            (import ./dev)
            (import ./hardware)
            (import ./networking)
            (import ./zen)
          ]
        else
          [

          ]
      )
      ++ (
        if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") && (user != "root") then
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
      inputs.nixvim.nixosModules.nixvim
      inputs.nix-doom-emacs-unstraightened.homeModule
    ];
    users = {
      ${username} = homeConfig { user = username; };
      root = homeConfig { };
    };
  };
}
