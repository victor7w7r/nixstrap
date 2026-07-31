{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "diskonaut";
  src = pkgs.runCommand "diskonaut-src-with-lock" { } ''
    mkdir -p $out
    cp -r ${inputs.diskonaut}/* $out/
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
