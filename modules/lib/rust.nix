{ inputs, lib, ... }:
{
  flake-file.inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  _module.args.rustCall =
    {
      pkgs,
      pname,
      src,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      postInstall ? "",
      installPhase ? "",
      cargoHash ? lib.fakeHash,
      version ? "latest",
    }:
    let
      customRustToolchain =
        (pkgs.extend (import inputs.rust-overlay)).rust-bin.stable.latest.default.override
          {
            extensions = [
              "rust-src"
              "rust-analyzer"
            ];
          };

      customRustPlatform = pkgs.makeRustPlatform {
        cargo = customRustToolchain;
        rustc = customRustToolchain;
      };
    in
    customRustPlatform.buildRustPackage {
      inherit
        pname
        postInstall
        version
        installPhase
        cargoHash
        buildInputs
        src
        ;
      nativeBuildInputs =
        with pkgs;
        [
          sccache
          clang
          mold
        ]
        ++ nativeBuildInputs;
      SCCACHE_DIR = "/var/cache/sccache";
      RUSTFLAGS = "-C linker=clang -C link-arg=-fuse-ld=mold";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      doCheck = false;
    };
}
