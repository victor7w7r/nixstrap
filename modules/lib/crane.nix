{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "crane" false) ];

  crane.lib.call =
    {
      pkgs,
      pname,
      src,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
    }:
    let
      craneLib = inputs.crane.mkLib pkgs;
      commonArgs = {
        inherit nativeBuildInputs buildInputs src;
        strictEnv = true;
      };
    in
    craneLib.buildPackage (
      commonArgs
      // {
        inherit pname;
        version = "latest";
        cargoArtifacts = craneLib.buildDepsOnly commonArgs;
        doCheck = false;
      }
    );
}
