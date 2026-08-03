{
  kernel.config.denial.net-hardware = rec {
    all = cable // general // usb // wifi;

    cable = {
      BNGE = "n";
      BNX2X = "n";
      BNXT = "n";
      "8139CP" = "n";
      "8139TOO" = "n";
      ADIN1100_PHY = "n";
      ADIN_PHY = "n";
      AIR_EN8811H_PHY = "n";
      AMD_PHY = "n";
      AQUANTIA_PHY = "n";
      AS21XXX_PHY = "n";
      AT803X_PHY = "n";
      BCM54140_PHY = "n";
      BCM84881_PHY = "n";
      BCM87XX_PHY = "n";
      BROADCOM_PHY = "n";
      CICADA_PHY = "n";
      CORTINA_PHY = "n";
      DAVICOM_PHY = "n";
      DP83822_PHY = "n";
      DP83848_PHY = "n";
      DP83867_PHY = "n";
      DP83869_PHY = "n";
      DP83TC811_PHY = "n";
      DP83TD510_PHY = "n";
      DP83TG720_PHY = "n";
      FDDI = "n";
      ICPLUS_PHY = "n";
      INTEL_XWAY_PHY = "n";
      LSI_ET1011C_PHY = "n";
      LXT_PHY = "n";
      MARVELL_10G_PHY = "n";
      MARVELL_88Q2XXX_PHY = "n";
      MARVELL_88X2222_PHY = "n";
      MARVELL_PHY = "n";
      MAXLINEAR_86110_PHY = "n";
      MAXLINEAR_GPHY = "n";
      MCB = "n";
      MEDIATEK_GE_PHY = "n";
      MICREL_PHY = "n";
      MICROCHIP_T1S_PHY = "n";
      MICROCHIP_T1_PHY = "n";
      MICROSEMI_PHY = "n";
      NATIONAL_PHY = "n";
      NCN26000_PHY = "n";
      NXP_C45_TJA11XX_PHY = "n";
      NXP_CBTX_PHY = "n";
      NXP_TJA11XX_PHY = "n";
      QCA808X_PHY = "n";
      QCA83XX_PHY = "n";
      QSEMI_PHY = "n";
      RENESAS_PHY = "n";
      RTASE = "n";
      SFP = "n";
      STE10XP = "n";
      TERANETICS_PHY = "n";
      VITESSE_PHY = "n";
      XILINX_GMII2RGMII = "n";
      JME = "n";
      NET_VENDOR_INTEL = "n";
      SYSTEMPORT = "n";
    };

    general = {
      "6LOWPAN" = "n";
      B43 = "n";
      B43LEGACY = "n";
      B44 = "n";
      CAN = "n";
      ETHOC = "n";
      FEALNX = "n";
      IEEE802154 = "n";
      PPP = "n";
      SLIP = "n";
      WWAN = "n";
    };

    usb = {
      USB_NET_ZAURUS = "n";
      USB_NET_INT51X1 = "n";
      USB_NET_GL620A = "n";
      USB_NET_NET1080 = "n";
      USB_NET_PLUSB = "n";
      USB_NET_CX82310_ETH = "n";
      USB_NET_KALMIA = "n";
    };

    wifi = {
      MAC80211_HWSIM = "n";
      MT7601U = "n";
      MT7603E = "n";
      MT7615E = "n";
      MT7663S = "n";
      MT7663U = "n";
      MT76x0E = "n";
      MT76x0U = "n";
      MT76x2E = "n";
      MT76x2U = "n";
      MT7915E = "n";
      MT7925E = "n";
      MT7925U = "n";
      MT7996E = "n";
      VIRT_WIFI = "n";
    };
  };
}
