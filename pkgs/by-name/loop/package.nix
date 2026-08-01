{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "loop";
  src = pkgs.runCommand "loop-src-with-lock" { } ''
    mkdir -p $out
    cp -r ${inputs.loop}/* $out/
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
