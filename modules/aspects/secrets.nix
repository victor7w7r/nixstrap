{ inputs, ... }:
{
  flake-file.inputs.agenix.url = "github:ryantm/agenix";

  den.aspects.secrets = {
    nixos = {
      imports = [ inputs.agenix.nixosModules.default ];
      systemd.services.nixos-activation = {
        after = [ "sshd.service" ];
        wants = [ "sshd.service" ];
      };

      age.identityPaths = [
        "/nix/persist/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };
}
