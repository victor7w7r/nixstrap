{
  config,
  pkgs,
  host,
  lib,
  username,
  ...
}:
let
  specialHosts = (host == "v7w7r-macmini81" || host == "v7w7r-youyeetoox1");
in
{
  boot.initrd.systemd.services = {
    rollback-zfs = lib.mkIf specialHosts {
      wantedBy = [ "initrd.target" ];
      before = [ "initrd-fs.target" ];
      after = [
        "zfs-setimport.service"
        "zfs-load-key.service"
      ];
      path = [ config.boot.zfs.package ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = "zfs rollback -r zroot/local/root@empty";
    };

    rollback-btrfs = lib.mkIf (!specialHosts) {
      wantedBy = [ "initrd.target" ];
      after = [ "initrd-root-device.target" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/vg0/system /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
  };

  systemd = lib.mkIf specialHosts {
    shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source = lib.mkForce (
      pkgs.writeShellScript "zpool-sync-shutdown" ''
        ${config.boot.zfs.package}/bin/zfs destroy "zroot/local/root@lastboot" 2>/dev/null || true
        ${config.boot.zfs.package}/bin/zfs snapshot "zroot/local/root@lastboot"
        ${config.boot.zfs.package}/bin/zfs rollback -r "zroot/local/root@empty"
        exec ${config.boot.zfs.package}/bin/zpool sync
      ''
    );
    shutdownRamfs.storePaths = [ "${config.boot.zfs.package}/bin/zfs" ];
  };

  /*
    impermanence.ignorePaths = [
    "/etc/NIXOS"
    "/etc/.clean"
    "/etc/.updated"
    "/etc/.pwd.lock"
    "/var/.updated"
    "/etc/subgid"
    "/etc/subuid"
    "/etc/shadow"
    "/etc/group"
    "/etc/passwd"
    "/root/.nix-channels"
    ];
  */

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/var/log"
      "/var/lib/alsa"
      "/var/lib/bluetooth"
      "/var/lib/pve-cluster"
      "/var/lib/NetworkManager"
      "/var/lib/nixos"
      {
        directory = "/var/lib/sbctl";
        mode = "0700";
      }
      "/var/lib/systemd"
      "/var/lib/tailscale"
      "/var/lib/sops-nix"
      "/var/lib/tpm2-tss"
    ];
    files = [
      "/etc/adjtime"
      "/etc/logo.svg"
      "/etc/machine-id"
      "/etc/zfs/zpool.cache"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users."${username}" = {
      directories = [
        "Documentos"
        "Descargas"
        "Imágenes"
        "repositories"
        ".ssh"
        ".zen"
        ".local/share/baloo"
        ".local/share/kwalletd"
        ".local/share/Trash"
        ".doom.d"
        ".config/sops"
        ".config/nix"
        ".steam"
        ".tmux"
        #".cache"
      ];
      files = [
        ".bash_history"
        ".config/kwinoutputconfig.json"
        ".zsh_history"
      ];
    };
  };
}
