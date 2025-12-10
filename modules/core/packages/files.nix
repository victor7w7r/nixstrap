{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      superfile
      termscp
      tran
      trash-cli
      tuifimanager
      walk
      #https://github.com/mananapr/cfiles
      #https://codeberg.org/sylphenix/sff
      #https://github.com/nore-dev/fman
      #https://github.com/sorairolake/hf

      dust
      dua
      gdu
      ncdu
      #diskonaut

      duff
      fclones
      mmv-go
      fdupes
      rdfind
      rnr
    ];

  programs = {
    yazi.enable = true;
  };
}
