let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { size = "90G"; };
    systempv = (import ../lib/luks-lvm.nix) {
      size = "95G";
      group = "emmc";
      vg = "vg0";
      priority = 4;
    };
    shared = (import ../lib/shared.nix) { };
  };

  lvs = {
    swapcrypt = (import ../lib/swap.nix) {
      discardPolicy = "once";
    };
    syscrypt = (import ../lib/f2fs.nix) {
      name = "system";
      mountpoint = "/nix";
      size = "100%";
      postCreateHook = "mkdir -p persist";
    };
  };

in
{
  disko.devices = {
    disk.emmc = {
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

  roottmp."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "defaults"
      "size=2G"
      "mode=755"
    ];
  };

}
