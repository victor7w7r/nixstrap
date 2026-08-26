{
  den.aspects.superlab.initrd.nixos = { config, ... }: {
    boot.initrd = {
      systemd = {
        tpm2.enable = false;
        storePaths = map (fw: {
          source = "${config.hardware.firmware}/lib/firmware/arm/mali/arch10.8/${fw}";
          target = "/extra-firmware/arm/mali/arch10.8/${fw}";
        }) [ "mali_csffw.bin" ];
      };
      kernelModules = [
        "display_connector"
        "dm_crypt"
        "dm_mod"
        "hantro_vpu"
        "panthor"
        "phy_rockchip_samsung_hdptx"
        "pinctrl_rk805"
        "pwm_fan"
        "rk805_pwrkey"
        "rng_core"
        "rk_crypto2"
        "rockchip_rga"
        "rockchip_rng"
        "rockchip_vdec"
        "rockchipdrm"
        "rocket"
        "rtc_hym8563"
        "sg"
        "sm3_generic"
        "snd_soc_audio_graph_card"
        "snd_soc_es8316"
        "spi_rockchip_sfc"
        "synopsys_hdmirx"
        "trusted"
        "uas"
        "usbhid"
        #"resume=${config.boot.resumeDevice}"
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
  };
}
