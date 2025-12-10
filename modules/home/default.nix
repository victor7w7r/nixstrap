{
  inputs,
  username,
  host,
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
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];

    users.${username} = {
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;

      imports = [
        (import ./system)
        (import ./dev)
        (import ./disks)
        (import ./net)
        (import ./plasma)
        (import ./theme)
      ]
      ++ (
        if (host != "vm") || (host != "server") then
          [
            (import ./eq)
            (import ./gaming)
            (import ./multimedia)
            #(import ./hypr)
            (import ./post-production)
            (import ./util)
          ]
        else
          [ ]
      );
    };
  };
}
