{ inputs, ... }:
{
  den = {
    #nix build ".#nixosConfigurations.test.config.system.build.squashfs" --print-out-paths
    #nix build ".#nixosConfigurations.test.config.system.build.metadata" --print-out-paths
    #incus image import --alias test .tar.xz /nixos-lxc-image-x86_64-linux.squashfs
    #incus launch test -c security.nesting=true
    #incus shell square-heron

    hosts.x86_64-linux.test.users.victor7w7r = { };
    aspects.test = {
      nixos = { lib, pkgs, ... }: {
        imports = [ "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix" ];
        boot.modprobeConfig.enable = lib.mkForce false;
        boot.isContainer = true;
        environment.systemPackages = [ pkgs.sl ];
      };
    };
  };
}
