{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "crane" false) ];

  crane.lib.call =
    {
      pkgs,
      pname,
      source,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
    }:
    let
      craneLib = inputs.crane.mkLib pkgs;
      commonArgs = {
        src = craneLib.cleanCargoSource source;
        inherit nativeBuildInputs buildInputs;
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
