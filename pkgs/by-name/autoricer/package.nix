{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "autoricer";
  src = pkgs.runCommand "autoricer-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.autoricer} $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
