{ inputs, ... }:
{
  den = {
    #nix build .#nixosConfigurations.test.config.system.build.squashfs --print-out-paths
    #nix build .#nixosConfiguration.test.config.system.build.metadata --print-out-paths
    #incus image import --alias nixos/test/container /nix/store/.../tarball/nixos-system-x86_64-linux.tar.xz /nix/store/...
    #incus image list nixos/test/container
    #incus launch nixos/test/container -c security.nesting=true
    #incus shell square-heron
    hosts.x86_64-linux.test.users.victor7w7r = { };
    aspects.test = {
      nixos = { lib, pkgs, ... }: {
        imports = [ "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix" ];
        boot.modprobeConfig.enable = lib.mkForce false;
        environment.systemPackages = [ pkgs.sl ];
      };
    };
  };
}
