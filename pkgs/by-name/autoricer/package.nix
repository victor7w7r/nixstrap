{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "autoricer";
  cargoHash = "sha256-Wcx8cYU1aVvCpngl5dpODbZJGpS9rGzYJ4BB7gyGtSQ=";
  src = pkgs.runCommand "autoricer-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.autoricer} $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
