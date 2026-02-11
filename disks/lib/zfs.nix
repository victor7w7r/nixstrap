{
  partition =
    {
      priority ? "100",
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
      mode ? null,
      vdev ? [ ],
      log ? [ ],
      special ? [ ],
      cache ? [ ],
      postCreateHook ? "",
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
          postCreateHook;
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        mountpoint = "none";
        canmount = "off";
        checksum = "edonr";
        normalization = "formD";
        dnodesize = "auto";
        xattr = "sa";
      };
      mode = (
        if mode == null then
          {
            topology = {
              type = "topology";
              inherit
                vdev
                log
                special
                cache
                ;
            };
          }
        else
          mode
      );
    };

  #Parent
  preDataset =
    {
      name ? "safe",
    }:
    {
      "${name}" = {
        type = "zfs_fs";
        options = {
          mountpoint = "none";
          canmount = "off";
        };
      };
    };

  #ZFS_FS Vol
  dataset =
    {
      preDataset ? "safe",
      pool ? "zroot",
      name ? "root",
      mountpoint ? "/",
      options ? { },
      isRoot ? false,
      enableSnap ? true,
    }:
    {
      "${preDataset}/${name}" = {
        type = "zfs_fs";
        options = {
          mountpoint = "legacy";
          atime = "off";
        }
        // options;
        inherit mountpoint;
        postCreateHook = ''
          ${
            if isRoot then
              ''
                zfs snapshot zroot/${preDataset}/root@empty
                zfs snapshot zroot/${preDataset}/root@lastboot
              ''
            else
              ""
          }
          ${
            if enableSnap then
              ''
                zfs list -t snapshot -H -o name \
                | grep -E '^${pool}/${preDataset}/${name}@empty$' \
                || zfs snapshot ${pool}/${preDataset}/${name}@empty
              ''
            else
              ""
          }
        '';
      };
    };

  #ZVol Sparse
  volume =
    {
      preDataset ? "safe",
      name,
      content ? null,
      size,
      options ? { },
      postCreateHook ? "",
    }:
    {
      "${preDataset}/${name}" = {
        type = "zfs_volume";
        options = {
          volblocksize = "4096";
          "com.sun:auto-snapshot" = "false";
        }
        // options;
        inherit
          size
          content
          postCreateHook
          ;
      };
    };
}
