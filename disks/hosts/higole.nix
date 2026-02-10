let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { size = "90G"; };
    systempv = (import ../lib/luks-lvm.nix) {
      size = "75G";
      vg = "vg0";
      priority = 4;
    };
    shared = (import ../lib/shared.nix) { };
  };

  lvs = {
    swapcrypt = (import ../lib/swap.nix) {
      discardPolicy = "once";
    };
    # CHECK EMMC QUALITY
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      size = "100%";
      #subvolumes = (import ../lib/subvolumes-btrfs.nix) { };
    };
  };

in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/mmcblk0";
      content = {
        type = "gpt";
        inherit partitions;
      };
    };
    lvm_vg."vg0" = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
