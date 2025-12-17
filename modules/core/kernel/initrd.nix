{
  config,
  pkgs,
  ...
}:
{
  boot.initrd = {
    services.lvm.enable = true;
    compressor = "xz";
    compressorArgs = [
      "--check=crc32"
      "--lzma2=dict=6MiB"
      "-T0"
    ];

    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        #ssh-keygen -t ed25519 -N "" -f ./ssh_host_ed25519_key
        #ssh-keygen -t rsa -N "" -f ./ssh_host_rsa_key
        hostKeys = [
          "/etc/secrets/initrd/ssh_host_rsa_key" = builtins.path { path = "${self}/ssh_host_rsa_key"; };
          "/etc/secrets/initrd/ssh_host_ed25519_key" = builtins.path { path = "${self}/ssh_host_ed25519_key"; };
        ];
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJWCZ9+MLQa24ySonjLfwdsV7DfBi40EkpZ+EswLEG+ arkano036@gmail.com"
        ];
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
        gping = "${pkgs.gping}/bin/gping";
        grep = "${pkgs.gnugrep}/bin/grep";
        busybox = "${pkgs.busybox}/bin/busybox";
      };
      services.fsmount = {
        description = "Custom Filesystem Mount";
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        wantedBy = [ "initrd.target" ];
        before = [ "initrd-find-nixos-closure.service" ];
        after = [ "sysroot.mount" ];
        script = ''
          OPTS=noatime,lazytime,nobarrier,nodiscard,commit=120

          if ! e2fsck -n ${config.setupDisks.systemDisk}; then e2fsck -y ${config.setupDisks.systemDisk}; fi
          if ! e2fsck -n ${config.setupDisks.varDisk}; then e2fsck -y ${config.setupDisks.varDisk}; fi
           ${
             if config.setupDisks.homeDisk != "" then
               "if ! e2fsck -n ${config.setupDisks.homeDisk}; then e2fsck -y ${config.setupDisks.homeDisk}; fi"
             else
               ""
           }
          ${if config.setupDisks.extraFsck != "" then config.setupDisks.extraFsck else ""}

          mkdir -p /run/troot
          mount --make-private /sysroot 2>> /run/.root.log
          mount --make-private / 2>> /run/.root.log
          mount --make-private /run 2>> /run/.root.log
          mount -t tmpfs -o size=4G,mode=1755 tmpfs /run/troot

          cp -a -r "/sysroot/bin" "/run/troot/"
          cp -a -r "/sysroot/lib64" "/run/troot/"

          for dir in boot etc nix root var home usr .nix tmp; do mkdir -p "/run/troot/$dir"; done

          ${if config.setupDisks.kvmDisk != "" then ''mkdir -p "/run/troot/kvm'' else ""}
          ${
            if config.setupDisks.extraDir != "" then
              ''for secDir in ${config.setupDisks.extraDir}; do mkdir -p "/run/troot/$secDir"; done''
            else
              ""
          }

          mount --move /run/troot /sysroot
          mount -t ext4 -o $OPTS ${config.setupDisks.systemDisk} /sysroot/.nix
          ${
            if config.setupDisks.homeDisk != "" then
              "mount -t ext4 -o $OPTS ${config.setupDisks.homeDisk} /sysroot/home"
            else
              ""
          }
          mount -t ext4 -o $OPTS ${config.setupDisks.varDisk} /sysroot/var

          ${
            if config.setupDisks.kvmDisk != "" then
              "mount -t ext4 -o $OPTS ${config.setupDisks.kvmDisk} /sysroot/kvm"
            else
              ""
          }
          ${if config.setupDisks.extraMount != "" then config.setupDisks.extraMount else ""}

          mount --bind /sysroot/.nix/root /sysroot/root
          mount --bind /sysroot/.nix/etc /sysroot/etc
          mount --bind /sysroot/.nix/nix /sysroot/nix
          ${if config.setupDisks.homeDisk == "" then "mount --bind /sysroot/.nix/home /sysroot/home" else ""}

          mount -t tmpfs -o mode=1777 tmpfs /sysroot/tmp || true
          mount -t tmpfs -o mode=1777 tmpfs /sysroot/var/tmp || true
          mount -t tmpfs -o mode=1777 tmpfs /sysroot/var/cache || true
        '';
      };
    };
  };
}
