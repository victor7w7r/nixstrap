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

      age.identityPaths = [
        "/nix/persist/etc/ssh/ssh_host_ed25519_key"
      ];
    };

    /*
      provides.to-users.homeManager = { config, ... }: {
       imports = [ inputs.agenix.homeManagerModules.default ];

       age = {
         secrets.yubikey = {
           file = "${self}/assets/secrets/yabe.age";
           path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";
           mode = "770";
         };
         identityPaths = [
           "/nix/persist/etc/ssh/ssh_host_ed25519_key"
           "/nix/persist/etc/ssh/ssh_host_rsa_key"
         ];
       };
       };
    */
  };
}
