{ inputs, ... }:
{
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  den.default.nixos =
    {
      isPersistent,
      lib,
      user,
      ...
    }:
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      environment.persistence."/nix/persist" = lib.optionalAttrs isPersistent {
        hideMounts = true;
        directories = [
          "/etc/nixos"
          "/var/log"
          "/var/cache/ccache"
          "/var/cache/sccache"
          "/var/lib/chrony"
          "/var/lib/fail2ban"
          "/var/lib/lastlog"
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/lib/tailscale"
        ];
        files = [
          "/etc/adjtime"
          "/etc/logo.svg"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/machine-id"
        ];
        users = {
          "${user.name}".directories = [
            "Documentos"
            "Descargas"
            "Imagenes"
            "repositories"
            "scripts"
            "remote"
            ".cache/thumbnails"
            ".config/nix"
            ".config/freerdp"
            ".config/Seafile"
            ".local/share/cod"
            ".local/share/Trash"
            ".local/share/zoxide"
            ".local/state"
            ".ssh"
            ".gnupg"
            ".ccnet"
          ];
          root.directories = [
            ".zsh"
            ".cache/antidote"
          ];
        };
      };
    };
}
