let
  common = import ./common.nix;
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          inherit (common) ESP SYSTEM;
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          fstemp = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = common.extCommonArgs ++ [
                "-L"
                "fstemp"
              ];
              mountOptions = common.extCommonOptions;
              postMountHook = ''
                #/mnt/kvm
                mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt
              '';
            };
          };
          var = {
            size = "5G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              extraArgs = common.extCommonArgs ++ [
                "-L"
                "var"
              ];
              mountOptions = common.extCommonOptions;
            };
          };
          home = {
            size = "10G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              extraArgs = common.extCommonArgs ++ [
                "-L"
                "home"
              ];
              mountOptions = common.extCommonOptions;
              postMountHook = "mkdir -p /home/common";
            };
          };
          system = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/.nix";
              extraArgs = common.extCommonArgs ++ [
                "-L"
                "system"
              ];
              mountOptions = common.extCommonOptions;
              postMountHook = ''
                mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root
                mount --bind /mnt/.nix/root /mnt/root
                mount --bind /mnt/.nix/etc /mnt/etc
                mount --bind /mnt/.nix/opt /mnt/opt
                mount --bind /mnt/.nix/nix /mnt/nix
              '';
            };
          };
        };
      };
    };
  };
}
