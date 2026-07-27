{ den, inputs, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

  imports = [
    (inputs.den.flakeModules.dendritic or { })
    (inputs.flake-file.flakeModules.dendritic or { })
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    flake-file.url = "github:vic/flake-file";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };

  den.default.includes =
    let
      __findFile = den.lib.take.unused __findFile den.lib.__findFile;
    in
    [
      den.batteries.inputs'
      den.batteries.self'
      <den/define-user>
      <den/primary-user>
      <den/mutual-provider>
      (<den/user-shell> "zsh")
    ];
}
