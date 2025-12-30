{ username, ... }:
{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "${username}" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ./secrets/example.yaml;
  sops.secrets."example" = { };
}
