{ kernel, ... }:
{
  kernel.patches.injector = pkgs: {
    asus = kernel.patches.asus pkgs;
    bunker = kernel.patches.bunker;
    cachyos = kernel.patches.cachyos pkgs;
    armbian = kernel.patches.armbian pkgs;
    hardened = kernel.patches.hardened pkgs;
    tachyon = kernel.patches.tachyon pkgs;
  };
}
