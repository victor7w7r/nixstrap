{
  den,
  disko,
  inputs,
  ...
}:
{
  perSystem.packages.generic-toplevel =
    inputs.self.nixosConfigurations.generic.config.system.build.toplevel;

  /*
    pkgsGuest = import nixpkgs {
       system = systemHost;
       crossSystem = {
         config = "aarch64-unknown-linux-gnu";
       };
     };

     # Evaluamos NixOS para el invitado ARM64
     arm64Vm = nixpkgs.lib.nixosSystem {
       system = "aarch64-linux";
       modules = [
         ({ pkgs, modulesPath, ... }: {
           virtualisation = {

             qemu.options = [
               "-machine" "virt"
               "-cpu" "cortex-a72"
               "-accel" "tcg,thread=multi"
             ];
           };

           /* qemu.options = [
                   "-machine" "q35"
                   "-cpu" "max" # O una CPU x86 específica como 'Nehalem' o 'Haswell'
                   "-accel" "tcg,thread=multi"
                 ];

           networking.hostName = "nixos-arm64-tcg";
         })
       ];
     };
    in
    {
     # Puedes ejecutarla directo con: nix run .#arm64-vm
     apps.${systemHost}.arm64-vm = {
       type = "app";
       program = "${arm64Vm.config.system.build.vm}/bin/run-${arm64Vm.config.system.name}";
     };
    };
  */

  den = {
    hosts = {
      x86_64-linux.generic-x86.users.snowflake = { };
      aarch64-linux.generic-arm64.users.snowflake = { };
    };

    aspects.generic = {
      includes = with den.aspects; [
        generic._

        cli._
        dev.mise
        gui._
        misc.comm
        misc.fetch
        zen._

        kitty
        plasma._
        secrets
      ];

      nixos = { pkgs, ... }: {
        nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.pinned ];
        networking.hostName = "v7w7r-generic";

        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages.linux-cachyos-latest-lto;
      };
    };
  };
}
