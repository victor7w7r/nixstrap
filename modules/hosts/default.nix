{ inputs, lib, ... }:
{
  imports = [ (inputs.den.namespace "hosts" false) ];

  hosts.lib.zram =
    {
      mappers ? [ ],
      isPercent ? false,
      percent ? "25",
      fixed ? "4G",
    }:
    {
      nixos =
        { pkgs, ... }:
        {
          boot.initrd.systemd.services.zram-format = {
            wantedBy = [ "initrd.target" ];
            requiredBy = [ "sysroot.mount" ];
            before = [
              "initrd-fs.target"
              "sysroot.mount"
            ]
            ++ mappers;
            after = [ "systemd-modules-load.service" ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            path = with pkgs; [
              coreutils
              e2fsprogs
              systemd
              util-linux
            ];
            script = ''
              ${lib.optionalString isPercent ''
                TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print $2 * 1024}')
                SIZE=$((TOTAL_MEM * ${percent} / 100))
              ''}
              echo ${if isPercent then "$SIZE" else fixed} > /sys/block/zram1/disksize
              mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1
            '';
          };
        };
    };
}
