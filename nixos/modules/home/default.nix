{
  inputs,
  username,
  host,
  pkgs,
  system,
  self,
  ...
}:
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

    users.${username} = {
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
      programs.home-manager.enable = true;

      imports = [
        (import ./desktop)
        (import ./dev)
        (import ./hardware)
        (import ./networking)
        (import ./system)
      ]
      ++ (
        if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") then
          [
            (import ./misc)
            (import ./multimedia)
            (import ./zen)
          ]
        else
          [ ]
      );
    };
  };
}
