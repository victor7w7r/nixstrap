{
  partition =
    {
      priority,
      pool ? "zroot",
      size ? "100%",
    }:
    {
      inherit size priority;
      content = {
        type = "zfs";
        inherit pool;
      };
    };

  entireDisk =
    {
      device,
      pool ? "zcloud",
    }:
    {
      type = "disk";
      device = "/dev/disk/by-id/${device}";
      content = {
        type = "zfs";
        inherit pool;
      };
    };

  pool =
    {
      datasets,
      isRoot ? false,
      vdev ? [ ],
      log ? [ ],
      special ? [ ],
      cache ? [ ],
    }:
    {
      type = "zpool";
      inherit datasets;
      postCreateHook =
        if isRoot then
          ''
            if ! zfs list -t snap zroot/local/root@empty; then
              zfs snapshot zroot/local/root@empty
            fi
          ''
        else
          "";
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        mountpoint = "none";
        compression = "zstd";
        canmount = "off";
        checksum = "edonr";
        keylocation = "none";
        normalization = "formD";
        dnodesize = "auto";
        xattr = "sa";
      };
      mode.topology = {
        type = "topology";
        inherit
          vdev
          log
          special
          cache
          ;
      };
    };

  dataset =
    {
      pool ? "zroot",
      name ? "root",
      mountpoint ? "/",
      options ? { },
      isRoot ? false,
    }:
    {
      "local/${name}" = {
        type = "zfs_fs";
        options = {
          mountpoint = "legacy";
          atime = "off";
        }
        // options;
        inherit mountpoint;
        postCreateHook =
          if isRoot then
            ''
              zfs snapshot zroot/local/root@empty;
              zfs snapshot zroot/local/root@lastboot;
            ''
          else
            ''
              zfs list -t snapshot -H -o name \
              | grep -E '^${pool}/local/${name}@empty$' \
              || zfs snapshot ${pool}/local/${name}@empty
            '';
      };
    };
}
