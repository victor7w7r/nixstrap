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
        language.base = "es_ES.UTF-8";
        homeDirectory = if user == "root" then "/root" else "/home/${user}";
        stateVersion = "26.05";
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
        if
          (host != "v7w7r-nixvm")
          && (host != "v7w7r-youyeetoox1")
          && (host != "v7w7r-opizero2w")
          && (user != "root")
        then
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
      inputs.zen-browser.homeModules.beta
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.nix-doom-emacs-unstraightened.homeModule
    ];
    users = {
      ${username} = homeConfig { user = username; };
      root = homeConfig { };
    };
  };
}
