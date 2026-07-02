{ den, inputs, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

  imports = [
    (inputs.den.flakeModules.dendritic or { })
    (inputs.flake-file.flakeModules.dendritic or { })
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  den.default.includes =
    let
      __findFile = den.lib.take.unused __findFile den.lib.__findFile;
    in
    [
      den.batteries.inputs'
      den.batteries.self'
      <den/define-user>
      <den/define-user>
      <den/primary-user>
      <den/mutual-provider>
      (<den/user-shell> "zsh")
    ];
}
