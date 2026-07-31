{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "autoricer";
  src = pkgs.runCommand "autoricer-src-with-lock" { } ''
    mkdir -p $out
    cp -r ${inputs.autoricer}/* $out/
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
