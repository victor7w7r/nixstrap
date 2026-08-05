{ inputs, lib, ... }:
{
  imports = [ (inputs.den.namespace "crane" false) ];

  crane.lib.call =
    {
      pkgs,
      pname,
      src,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      postInstall ? "",
      installPhase ? "",
      version ? "latest",
    }:
    let
      craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (
        _:
        pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
            "rustfmt"
          ];
        }
      );
      commonArgs = {
        inherit nativeBuildInputs buildInputs src;
        strictEnv = true;
      };
    in
    craneLib.buildPackage (
      commonArgs
      // {
        inherit pname postInstall version;
        cargoArtifacts = craneLib.buildDepsOnly commonArgs;
        doCheck = false;
        env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-error=incompatible-pointer-types";
      }
      // (lib.optionalAttrs (installPhase != "") {
        inherit installPhase;
      })
    );
}
