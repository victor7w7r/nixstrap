{
  den.aspects.superlab.initrd.nixos.boot.initrd = {
    tpm2.enable = false;
    kernelModules = [
      "display_connector"
      "dm_crypt"
      "dm_mod"
      "hantro_vpu"
      "panthor"
      "phy_rockchip_samsung_hdptx"
      "phy_rockchip_snps_pcie3"
      "pinctrl_rk805"
      "rng_core"
      "rockchip_rga"
      "rockchip_rng"
      "rockchip_vdec"
      "rockchipdrm"
      "rocket"
      "snd_soc_es8316"
      "snd_soc_audio_graph_card"
      "synopsys_hdmirx"
      "spi_rockchip_sfc"
      "usbhid"
      "resume=${config.boot.resumeDevice}"
    ];

    luks.devices = {
      swapcrypt = {
        device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
      system = {
        device = "/dev/disk/by-partlabel/disk-main-system";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
  };
}
