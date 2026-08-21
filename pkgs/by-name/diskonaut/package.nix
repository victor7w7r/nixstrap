{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "diskonaut";
  src = pkgs.runCommand "diskonaut-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.diskonaut} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
