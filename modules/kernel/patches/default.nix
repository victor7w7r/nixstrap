{ kernel, ... }:
{
  kernel.patches.injector = pkgs: {
    asus = kernel.patches.asus pkgs;
    bunker = kernel.patches.bunker;
    cachyos = kernel.patches.cachyos pkgs;
    qcom = kernel.patches.qcom;
    rockchip = kernel.patches.armbian.rockchip pkgs;
    sunxi = kernel.patches.armbian.sunxi pkgs;
    tachyon = kernel.patches.tachyon;
  };
}
