{ pkgs }:
pkgs.pkgsCross.aarch64-multiplatform.ubootRock5ModelB.overrideAttrs (oldAttrs: {
  extraConfig = ''
    CONFIG_DM_PCI_COMPAT=y
    CONFIG_PHY_ROCKCHIP_NANENG_EDP=y
    CONFIG_PHY_ROCKCHIP_SAMSUNG_HDPTX=y
    CONFIG_PHY_ROCKCHIP_SNPS_PCIE3=y
  '';
})
