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
    rollback-btrfs = lib.mkIf (host == "v7w7r-rc71l") {
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

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/ssh"
      "/var/log"
      "/var/lib"
    ];
    files = [
      "/etc/adjtime"
      "/etc/logo.svg"
      "/etc/machine-id"
      "/etc/zfs/zpool.cache"
    ];
    users.root.directories = [
      "/root/.zsh"
      "/root/.tmux"
      "/root/.cache/antidote"
    ];
    users."${username}" = {
      directories = [
        "Documentos"
        "Descargas"
        "Imágenes"
        "repositories"
        "scripts"
        "remote"
        ".cache/antidote"
        ".ssh"
        ".config/bruno"
        ".config/freerdp"
        ".config/JetBrains"
        ".config/legcord"
        ".config/nix"
        ".config/onlyoffice"
        ".config/sops"
        ".config/vlc"
        ".config/zen"
        ".local/state"
        ".local/share/baloo"
        ".local/share/cod"
        ".local/share/containers"
        ".local/share/com.vixalien.sticky"
        ".local/share/emacs"
        ".local/share/JetBrains"
        ".local/share/klipper"
        ".local/share/krdc"
        ".local/share/kwalletd"
        ".local/share/mise"
        ".local/share/nix"
        ".local/share/onlyoffice"
        ".local/share/PrismLauncher"
        ".local/share/Trash"
        ".local/share/vlc"
        ".local/share/zed"
        ".local/share/zoxide"
        ".local/share/waydroid"
        ".cargo"
        ".gnupg"
        ".rustup"
        ".steam"
        ".zsh"
        ".tmux"
      ];
      files = [
        ".bash_history"
        ".config/kwalletrc"
        ".config/kwinoutputconfig.json"
        ".zsh_history"
      ];
    };
  };
}
