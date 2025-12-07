{
  inputs,
  username,
  host,
  plasma-manager,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username host; };
    useUserPackages = true;
    useGlobalPkgs = true;
    modules = [ plasma-manager.homeModules.plasma-manager ];
    home = {
      username = "${username}";
      homeDirectory = "/home/${username}";
      stateVersion = "24.05";
    };
    programs.home-manager.enable = true;
    users.${username} = {
      imports = [
        ./system
        ./dev
        ./disks
        ./net
        ./theme
      ]
      ++ (
        if (host != "vm") || (host != "server") then
          [
            ./eq
            ./gaming
            ./multimedia
            ./hypr
            ./plasma
            ./post-production
            ./util
          ]
        else
          [ ]
      );
    };
  };
}
