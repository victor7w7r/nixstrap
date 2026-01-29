{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    clifm
    lf
    joshuto
    superfile
    termscp
    timg
    walk
  ];
}
