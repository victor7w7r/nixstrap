{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "loop";
  src = pkgs.runCommand "loop-src-with-lock" { } ''
    mkdir -p $out
    cp -r --no-target-directory ${inputs.loop} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
})
