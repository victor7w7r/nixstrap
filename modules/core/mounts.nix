{ config, ... }:

{
  boot.initrd.systemd.services.fsmount = {
    description = "Mount filesystems";
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = [ "initrd.target" ];
    before = [ "initrd-find-nixos-closure.service" ];
    after = [ "sysroot.mount" ];

    script = ''
      #!/bin/sh
      set -e
      set -x

      NEWROOT=/sysroot

      if ! e2fsck -n ${config.setupDisks.systemdisk}; then e2fsck -y ${config.setupDisks.systemdisk}; fi
      if ! e2fsck -n ${config.setupDisks.homedisk}; then e2fsck -y ${config.setupDisks.homedisk}; fi
      if ! e2fsck -n ${config.setupDisks.varDisk}; then e2fsck -y ${config.setupDisks.varDisk}; fi

      mkdir -p /run/troot
      mount --make-private "$NEWROOT" 2>> /run/.root.log
      mount --make-private / 2>> /run/.root.log
      mount --make-private /run 2>> /run/.root.log
      mount -t tmpfs -o size=4G,mode=1755 tmpfs /run/troot

      cp -a -r "$NEWROOT/bin" "/run/troot/"
      cp -a -r "$NEWROOT/lib64" "/run/troot/"

      for dir in boot etc nix root var home opt usr .nix tmp; do
        mkdir -p "/run/troot/$dir"
      done

      mount --move /run/troot "$NEWROOT"

      OPTS=noatime,lazytime,nobarrier,nodiscard,commit=120

      mount -t ext4 -o $OPTS ${config.setupDisks.systemdisk} "$NEWROOT"/.nix
      mount -t ext4 -o $OPTS ${config.setupDisks.homedisk} "$NEWROOT"/home
      mount -t ext4 -o $OPTS ${config.setupDisks.varDisk} "$NEWROOT"/var
      #chown -R wheel:users /home/common

      mount --bind "$NEWROOT"/.nix/root "$NEWROOT"/root
      mount --bind "$NEWROOT"/.nix/etc "$NEWROOT"/etc
      mount --bind "$NEWROOT"/.nix/opt "$NEWROOT"/opt
      mount --bind "$NEWROOT"/.nix/nix "$NEWROOT"/nix

      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/tmp || true
      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/var/tmp || true
      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/var/cache || true
    '';
  };
}
