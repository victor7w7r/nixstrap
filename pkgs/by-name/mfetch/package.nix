{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "mfetch";
  cargoHash = "sha256-Udh66rEV512yZYiTs1D6sgzo79+fOIWJOj9kK0cz04I=";
  src = pkgs.runCommand "mfetch-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.mfetch} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
