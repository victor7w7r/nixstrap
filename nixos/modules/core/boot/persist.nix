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
