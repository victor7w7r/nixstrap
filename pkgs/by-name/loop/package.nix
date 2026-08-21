{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "loop";
  cargoHash = "sha256-sceS/2qxiV16VP8E3M39MYnGiCbq0rrnehsV/SuHZl4=";
  src = pkgs.runCommand "loop-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.loop} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
