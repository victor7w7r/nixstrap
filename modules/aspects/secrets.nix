{ inputs, self, ... }:
{
  flake-file.inputs.agenix.url = "github:ryantm/agenix";

  den.aspects.secrets = {
    nixos = {
      imports = [ inputs.agenix.nixosModules.default ];
      systemd.services.nixos-activation = {
        after = [ "sshd.service" ];
        wants = [ "sshd.service" ];
      };

      age = {
        secrets.yubikey = {
          file = "${self}/assets/secrets/yabe.age";
          mode = "770";
          owner = "victor7w7r";
          group = "victor7w7r";
        };
        identityPaths = [
          "/nix/persist/etc/ssh/ssh_host_ed25519_key"
          "/nix/persist/etc/ssh/ssh_host_rsa_key"
        ];
      };
    };

    provides.to-users.homeManager = { config, ... }: {
      imports = [ inputs.agenix.nixosModules.default ];
      xdg.configFile."Yubico/u2f_keys".source = config.age.secrets.yubikey.path;
    };
  };
}
