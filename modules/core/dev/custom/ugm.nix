{ pkgs, ... }:
pkgs.runCommand "ugm"
  {
    nativeBuildInputs = [ pkgs.eget ];
  }
  ''
    mkdir -p $out/bin
    eget ariasmn/ugm --to $out/bin/ugm
    chmod +x $out/bin/ugm
  ''
