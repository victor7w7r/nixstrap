{ den, inputs, ... }:
{
  imports = [
    (inputs.den.flakeModules.dendritic or { })
    (inputs.flake-file.flakeModules.dendritic or { })
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    flake-file.url = "github:vic/flake-file";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  };

  _module.args = {
    __findFile = den.lib.__findFile;
    armPkgs = import inputs.nixpkgs {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    };

    x86Pkgs = import inputs.nixpkgs {
      localSystem = "aarch64-linux";
      crossSystem = "x86_64-linux";
    };
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
