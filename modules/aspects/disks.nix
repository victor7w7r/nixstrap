{
  den.aspects.disks = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mtools
          udiskie
        ];
      };
  };

  nixos =
    { pkgs, ... }:
    {
      environment.systemPackages =
        with pkgs;
        [
          btdu
          btrfs-progs
          exfatprogs
          f2fs-tools
          ntfs2btrfs
        ];

        services = {
          fstrim.enable = true;
          btrfs.autoScrub = {
            enable = false;
            interval = "weekly";
          };
          snapper = {
            snapshotRootOnBoot = true;
            persistentTimer = true;
          };
        };
    };
}
