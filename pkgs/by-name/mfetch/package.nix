{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "mfetch";
  cargoHash = "sha256-ywqXUp3X9Jf6O7OdWyyrUPaAJx+IAAvPQU+7nP2okpM=";
  src = pkgs.runCommand "mfetch-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.mfetch} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
