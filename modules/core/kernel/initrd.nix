{ ... }:
{
  boot.initrd = {
    enable = true;
    services.lvm.enable = true;
    secrets = {
      #"/extkey.key" = /run/secrets/extkey.key;
      #"/syskey.key" = null;
    };
    luks.devices = {
      system = {
        device = "/dev/disk/by-label/SYSTEM";
        #keyFile = "/syskey.key";
        allowDiscards = true;
        preLVM = true;
      };
    };
    systemd = {
      enable = true;
      emergencyAccess = true;
      extraBin = {
        ip = "${pkgs.iproute2}/bin/ip";
        bash = "${pkgs.bash}/bin/bash";
        find = "${pkgs.findutils}/bin/find";
        coreutils = "${pkgs.coreutils-full}/bin/coreutils";
        grep = "${pkgs.gnugrep}/bin/grep";
        ping = "${pkgs.iputils}/bin/ping";
        busybox = "${pkgs.busybox}/bin/busybox";
      };
    };
    compressor = "xz";
    compressorArgs = [
      "--check=crc32"
      "--lzma2=dict=6MiB"
      "-T0"
    ];
  };
}
