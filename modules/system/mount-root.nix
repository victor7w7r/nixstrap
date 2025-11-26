{ pkgs, ... }:

let
  rootmountScript = pkgs.runCommand "rootmount-script" { } ''
        mkdir -p $out
        cat > $out/rootmount.sh <<'EOF'
    #!/bin/sh
    set -e

    cryptsetup luksOpen /dev/disk/by-label/SYSTEM system --key-file=/etc/keys/syskey.key --allow-discards
    cryptsetup luksOpen /dev/disk/by-label/STORAGE storage --key-file=/etc/keys/extkey.key
    lvm vgscan && lvm vgchange -ay

    if ! e2fsck -n /dev/mapper/vg0-system; then e2fsck -y /dev/mapper/vg0-system; fi
    # ... sigue con el resto de checks y montajes tal como tienes ...
    # (mantén la lógica, tal vez querrás ajustar timeouts o comprobar device existence)
    EOF
        chmod 0755 $out/rootmount.sh
  '';

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

  boot.initrd.extraFiles = {
    "run/initrd-root/rootmount.sh".source = "${rootmountScript}/rootmount.sh";
    "etc/keys/syskey.key".source = "${sysKey}/syskey.key";
    "etc/keys/extkey.key".source = "${extKey}/extkey.key";
  };

  boot.initrd.systemd.services = {
    "rootmount.service".text = ''
      [Unit]
      Description=Unlock LUKS & mount root (initrd)
      DefaultDependencies=no
      Before=initrd-switch-root.service
      After=systemd-udev-settle.service

      [Service]
      Type=oneshot
      RemainAfterExit=yes
      ExecStart=/run/initrd-root/rootmount.sh

      [Install]
      WantedBy=initrd.target
    '';
  };
}
