{ ... }:
{
  den.aspects.generic.vm-guest.nixos = { pkgs, modulesPath, ... }: {
    imports = [
      "${modulesPath}/profiles/qemu-guest.nix"
      "${modulesPath}/virtualisation/qemu-vm.nix"
    ];

    virtualisation = {
      vmVariant.virtualisation.useEFIBoot = true;
      memorySize = 2048;
      cores = 4;
      diskSize = 20640;
    };

  };
}
