{
  den,
  inputs,
  __findFile,
  ...
}:
{
  imports = [
    (inputs.den.flakeModules.dendritic or { })
    (inputs.flake-file.flakeModules.dendritic or { })
  ];

  flake-file = {
    inputs = {
      den.url = "github:denful/den";
      determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      flake-file.url = "github:vic/flake-file";
      nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    };
  };

  _module.args.__findFile = den.lib.__findFile;

  den.default.includes = [
    den.batteries.inputs'
    den.batteries.self'
    <den/define-user>
    <den/primary-user>
    <den/mutual-provider>
    (<den/user-shell> "zsh")
  ];
}
