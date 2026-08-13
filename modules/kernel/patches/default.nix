{ kernel, ... }:
{
  kernel.patches.injector = pkgs: {
    armbian = kernel.patches.armbian pkgs;
    asus = kernel.patches.asus pkgs;
    bunker = kernel.patches.bunker;
    cachyos = kernel.patches.cachyos pkgs;
    qcom = kernel.patches.qcom;
    tachyon = kernel.patches.tachyon;
  };
}
