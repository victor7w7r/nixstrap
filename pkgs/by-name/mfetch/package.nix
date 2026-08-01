{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "mfetch";
  src = pkgs.runCommand "mfetch-src-with-lock" { } ''
    mkdir -p $out
    cp -r ${inputs.mfetch}/* $out/
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
