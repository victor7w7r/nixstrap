{ inputs, lib, ... }:
{
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
        (pkgs.extend (import inputs.rust-overlay)).rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
            "rustfmt"
          ];
        }
      );
      commonArgs = {
        nativeBuildInputs =
          with pkgs;
          [
            sccache
            clang
            mold
          ]
          ++ nativeBuildInputs;
        inherit buildInputs src;
        SCCACHE_DIR = "/var/cache/sccache";
        RUSTFLAGS = "-C linker=clang -C link-arg=-fuse-ld=mold -C target-cpu=native";
        RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
        doCheck = false;
        strictDeps = true;
      };
    in
    craneLib.buildPackage (
      commonArgs
      // {
        inherit pname postInstall version;
        cargoArtifacts = craneLib.buildDepsOnly commonArgs;
      }
      // (lib.optionalAttrs (installPhase != "") {
        inherit installPhase;
      })
    );
}
