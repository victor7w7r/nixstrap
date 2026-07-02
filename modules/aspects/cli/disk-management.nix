{
  den.aspects.cli.disk-management = {
    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          self'.packages.diskonaut
          dua
          duf
          duff
          dust
          dysk
          fclones
          fdupes
          gdu
          mmv-go
          ncdu
          rdfind
          rnr
          smartmontools
          testdisk
          wiper
        ];
      };
    nixos =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          self'.packages.btrfsd
          self'.packages.chkufsd
          self'.packages.compress
          self'.packages.ext4-crypt
          self'.packages.repair-usb-disc
          compsize
          httm
          gpart
          partclone
          parted
          tparted
          wipefreespace
        ];
      };
  };
}
