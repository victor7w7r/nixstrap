{ pkgs, ... }:

let
  sysKey = pkgs.runCommand "syskey" { } ''
    mkdir -p $out
    # coloca tu archivo real ./keys/syskey.key al lado del flake/ repo, o pásalo desde /etc/nixos/keys
    cp ./keys/syskey.key $out/syskey.key
    chmod 0400 $out/syskey.key
  '';

  extKey = pkgs.runCommand "extkey" { } ''
    mkdir -p $out
    cp ./keys/extkey.key $out/extkey.key
    chmod 0400 $out/extkey.key
  '';
in
{
  #boot.initrd.extraFiles = {
  # "etc/keys/syskey.key".source = "${sysKey}/syskey.key";
  #  "etc/keys/extkey.key".source = "${extKey}/extkey.key";
  #};

  boot.initrd.systemd.services.rootmount = {
    unitConfig = {
      Description = "Unlock LUKS & mount root (initrd)";
      DefaultDependencies = false;
      After = "systemd-udev-settle.service";
    };
    wantedBy = [ "initrd.target" ];
    before = [ "initrd-switch-root.service" ];
    after = [ "systemd-udev-settle.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      #!/bin/sh
      set -e

      cryptsetup luksOpen /dev/disk/by-label/SYSTEM system --key-file=/etc/keys/syskey.key --allow-discards
      cryptsetup luksOpen /dev/disk/by-label/STORAGE storage --key-file=/etc/keys/extkey.key
      lvm vgscan && lvm vgchange -ay

      if ! e2fsck -n /dev/mapper/vg0-system; then e2fsck -y /dev/mapper/vg0-system; fi
      # ... sigue con el resto de checks y montajes tal como tienes ...
      # (mantén la lógica, tal vez querrás ajustar timeouts o comprobar device existence)
    '';
  };
}
