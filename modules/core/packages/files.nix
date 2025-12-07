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
    broot.enable = true;
    mc.enable = true;
    nnn.enable = true;
    rclone.enable = true;
    vifm.enable = true;
    yazi.enable = true;
    xplr.enable = true;
  };
}
