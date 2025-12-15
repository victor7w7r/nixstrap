rec {
  linuxpart =
    {
      name,
      size,
      label,
      mountpoint,
      postMountHook ? "",
      extraArgs ? [ ],
      mountOptions ? [ ],
    }:
    {
      inherit name size;
      content = {
        type = "filesystem";
        format = "ext4";
        inherit mountpoint postMountHook;
        mountOptions = mountOptions ++ [
          "noatime"
          "lazytime"
          "nobarrier"
          "nodiscard"
          "commit=120"
        ];
        extraArgs = extraArgs ++ [
          "-F"
          "-E"
          "nodiscard,lazy_itable_init=1,lazy_journal_init=1"
          "-O"
          "64bit,dir_index,dir_nlink,ext_attr,extra_isize,extents,flex_bg,has_journal,meta_bg,sparse_super,\sparse_super2,uninit_bg,^resize_inode"
          "-L"
          label
        ];
      };
    };

  shared =
    {
      size ? "100%",
      name ? "Shared",
      mountpoint ? "/media/shared",
    }:
    {
      inherit name size;
      type = "8300";
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        inherit mountpoint;
        mountOptions = [
          "lazytime"
          "nodiscard"
          "commit=60"
          "noatime"
          "compress-force=zstd:7"
        ];
      };
    };

  cryptsys =
    {
      size ? "100%",
      name ? "cryptsystem",
      keyFile ? "/tmp/pass.key",
      index ? "0",
      group ? "vg",
    }:
    {
      inherit size;
      content = {
        type = "luks";
        inherit name;
        settings = {
          inherit keyFile;
          allowDiscards = true;
        };
        content = {
          type = "lvm_pv";
          vg = "${group}${index}";
        };
        preCreateHook = ''
          dd if=/dev/urandom of=/root/nixstrap/syskey.key bs=1 count=64
          chmod 0400 /root/nixstrap/syskey.key
          git config --global user.email "nixos@flake.com" && \
          git config --global user.name "nixosflake" && \
          git config --global --add safe.directory /root/nixstrap && \
          cd /root/nixstrap && git add . && git commit -m "Add Key"
        '';
        postCreateHook = ''
          cryptsetup config /dev/disk/by-partlabel/disk-main-cryptsys --label "SYSTEM"
          cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-cryptsys /root/nixstrap/syskey.key -d /tmp/pass.key
        '';
      };
    };

  mockpart =
    {
      extraDirs ? "",
    }:
    linuxpart {
      name = "fstemp";
      size = "100M";
      label = "fstemp";
      mountpoint = "/";
      postMountHook = ''
        mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt ${extraDirs}
      '';
    };

  varpart = linuxpart {
    name = "var";
    size = "5G";
    label = "var";
    mountpoint = "/var";
  };

  homepart =
    {
      size ? "10G",
    }:
    linuxpart {
      inherit size;
      name = "home";
      label = "home";
      mountpoint = "/home";
      postMountHook = "mkdir -p /home/common";
    };

  kvmpart = linuxpart {
    name = "kvm";
    size = "100%";
    label = "kvm";
    mountpoint = "/kvm";
  };

  syspart =
    {
      extraDirs ? "",
      extraBinds ? "",
    }:
    linuxpart {
      name = "system";
      size = "100%";
      label = "system";
      mountpoint = "/.nix";
      postMountHook = ''
        mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root ${extraDirs}
        mount --bind /mnt/.nix/root /mnt/root
        mount --bind /mnt/.nix/etc /mnt/etc
        mount --bind /mnt/.nix/opt /mnt/opt
        mount --bind /mnt/.nix/nix /mnt/nix
        ${extraBinds}
      '';
    };
}
