{ kernel, ... }:
{
  kernel.patches.injector = pkgs: {
    asus = kernel.patches.asus pkgs;
    bunker = kernel.patches.bunker pkgs;
    cachyos = kernel.patches.cachyos pkgs;
    armbian = kernel.patches.armbian pkgs;
    sunxi-wifi = kernel.patches.armbian.sunxi-wifi pkgs;
    tachyon = kernel.patches.tachyon pkgs;
  };
}
