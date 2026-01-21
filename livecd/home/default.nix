{ flavor, pkgs, ... }:
let
  packages = with pkgs; [
    clolcat
    fortune
  ];
  commonImports = [
    (import ./config.nix)
    (import ./starship.nix)
  ];
in
{
  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    useUserPackages = true;
    useGlobalPkgs = true;

    users = {
      root = {
        programs.home-manager.enable = true;
        home = { inherit packages; };
        imports = commonImports;
        stateVersion = "24.05";
      };
      nixstrap = {
        programs.home-manager.enable = true;
        home = {
          inherit packages;
          username = "nixstrap";
          homeDirectory = "/home/nixstrap";
          stateVersion = "24.05";
        };
        imports =
          commonImports
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
  };
}
