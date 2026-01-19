{ flavor, pkgs, ... }:
{
  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    useUserPackages = true;
    useGlobalPkgs = true;

    users.nixstrap = {
      programs.home-manager.enable = true;
      home = {
        username = "nixstrap";
        homeDirectory = "/home/nixstrap";
        stateVersion = "24.05";
        packages = with pkgs; [
          clolcat
          fortune
        ];
      };

      imports = [
        (import ./config.nix)
        (import ./starship.nix)
      ]
      ++ (
        if (flavor == "graphical") then
          [
            (import ./desktop.nix)
            (import ./kitty.nix)
            (import ./theme.nix)
            (import ./xfce-panel.nix)
          ]
        else
          [ ]
      );
    }
    // (
      if (flavor == "graphical") then
        {
          services.network-manager-applet.enable = true;
        }
      else
        { }
    );
  };
}
