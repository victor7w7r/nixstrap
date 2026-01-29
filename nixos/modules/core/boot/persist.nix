{ lib, ... }:
{
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/mapper/syscrypt /btrfs_tmp
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

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [ "/etc/machine-id" ];
    users.gatien = {
      directories = [
        ".ssh"
        "Documents"
        "Downloads"
        "Games"
        "NixFlakes"
        ".zen"
        ".vscode"
        ".config/sops"
        ".steam"
        ".local/share/PrismLauncher"
        #".cache"
      ];
      files = [
        ".bash_history"
        ".zsh_history"
      ];
    };
  };
}
