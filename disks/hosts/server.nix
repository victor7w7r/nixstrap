let
  boot = import ../modules/boot.nix;
  linux = import ../modules/linux.nix;

  esp = boot.esp { };
  vault = boot.vault { };
  cryptsys = linux.cryptsys { };

  msr = winmod.msr { };
  recovery = winmod.recovery { };
  win = winmod.win { size = "100%"; };

  fstemp = linux.mockpart { };
  home = linux.homepart { };
  var = linux.varpart { };
  system = linux.syspart { };

  partitions = { inherit esp vault cryptsys; };
  satapartitions = { inherit msr recovery win; };
  lvs = { inherit fstemp home var system; };
in
{
  disko.devices = {
    disk = {
      stick = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = { type = "gpt"; inherit partitions; };
      };
      sata = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            win = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ntfs";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          fstemp = common.extpart {
            postMountHook = ''
              mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt /mnt/kvm /mnt/media
            '';
          };
          var = common.extpart {
            size = "5G";
            mountpoint = "/var";
          };
          home = common.extpart {
            size = "10G";
            mountpoint = "/home";
            postMountHook = "mkdir -p /home/common";
          };
          system = common.extpart {
            size = "60G";
            mountpoint = "/.nix";
            postMountHook = ''
              mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root
              mount --bind /mnt/.nix/root /mnt/root
              mount --bind /mnt/.nix/etc /mnt/etc
              mount --bind /mnt/.nix/opt /mnt/opt
              mount --bind /mnt/.nix/nix /mnt/nix
            '';
          };
          kvm = common.extpart {
            size = "100%";
            mountpoint = "/kvm";
          };
        };
      };
    };
  };
}
