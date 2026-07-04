{ lib, ... }:
{
  flake-file.inputs.claude-desktop = {
    url = "github:k3d3/claude-desktop-linux-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.dev.ide =
    { user, ... }:
    {
      nixos.environment.persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [
        ".config/bruno"
        ".config/Claude"
        ".config/JetBrains"
        ".local/share/JetBrains"
      ];

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            bruno
            jetbrains.datagrip
            windterm
            meld
            (inputs.claude-desktop.packages.${system}.claude-desktop.override {
              nodePackages = { inherit (pkgs) asar; };
            })
          ];
        };
    };
}
