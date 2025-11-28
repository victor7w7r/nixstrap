{ systemdisk, homedisk, varDisk, ... }:

{
  boot.initrd.systemd.services.rootmount = {
    description = "Mount root";
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = [ "initrd.target" ];
    before = [ "initrd-fs.target" ];
    after = [ "sysroot.mount" ];

    script = ''
      #!/bin/sh
      set -e
      set -x

      NEWROOT=/sysroot

      if ! e2fsck -n ${systemdisk}; then e2fsck -y ${systemdisk}; fi
      if ! e2fsck -n ${homedisk}; then e2fsck -y ${homedisk}; fi
      if ! e2fsck -n ${varDisk}; then e2fsck -y ${varDisk}; fi

      mkdir -p /run/troot
      mount --make-private "$NEWROOT" 2>> /run/.root.log
      mount --make-private / 2>> /run/.root.log
      mount --make-private /run 2>> /run/.root.log
      mount -t tmpfs -o size=4G,mode=1755 tmpfs /run/troot

      cp -a -r "$NEWROOT/bin" "/run/troot/"
      cp -a -r "$NEWROOT/lib64" "/run/troot/"

      for dir in .varfs .rootfs media/ext media/vm home etc usr nix mnt root var opt boot tmp; do
        mkdir -p "/run/troot/$dir"
      done

      mount --move /run/troot "$NEWROOT"

      OPTS=noatime,lazytime,nobarrier,nodiscard,commit=120

      #mount -t vfat /dev/disk/by-label/EFI "$NEWROOT"/boot
      mount -t ext4 -o $OPTS ${systemdisk} "$NEWROOT"/.rootfs
      mount -t ext4 -o $OPTS ${homedisk} "$NEWROOT"/media/ext
      mount -t ext4 -o $OPTS ${varDisk} "$NEWROOT"/.varfs

      mount --bind "$NEWROOT"/.rootfs/etc "$NEWROOT"/etc
      mount --bind "$NEWROOT"/.rootfs/nix "$NEWROOT"/nix
      mount --bind "$NEWROOT"/.varfs/var "$NEWROOT"/var
      mount --bind "$NEWROOT"/.varfs/root "$NEWROOT"/root

      mount --bind "$NEWROOT"/media/ext/.fs/home "$NEWROOT"/home
      mount --bind "$NEWROOT"/media/ext/.fs/opt "$NEWROOT"/opt
      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/tmp || true
      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/var/tmp || true
      mount -t tmpfs -o mode=0777 tmpfs "$NEWROOT"/var/cache || true
    '';
  };
}
