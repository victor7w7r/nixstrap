{
  inputs,
  username,
  host,
  pkgs,
  system,
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
        ;
    };
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.zen-browser.homeModules.beta
    ];

    users.${username} = {
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;

      imports = [
        (import ./desktop)
        (import ./dev)
        (import ./hardware)
        (import ./networking)
        (import ./system)
        (import ./zen)
      ]
      ++ (
        if (host != "v7w7r-nixvm") || (host != "v7w7r-youyeetoox1") then
          [
            (import ./misc)
            (import ./multimedia)
          ]
        else
          [ ]
      );
    };
  };
}
