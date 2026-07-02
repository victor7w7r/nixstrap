{ den, ... }:
{
  den.policies = {
    host-guards =
      { host, ... }:
      [
        (den.lib.policy.resolve {
          isGeneric = host.name == "generic";
          isHandheld = host.name == "handheld";
          isMinimalLive = host.name == "minimal-live";
          isGraphicalLive = host.name == "graphical-live";
          isMain = host.name == "main";
          isMainMac = host.name == "main-mac";
          isPhoneEnchilada = host.name == "phone-enchilada";
          isPhoneFajita = host.name == "phone-fajita";

          isPiZero = host.name == "pizero";
          isServer = host.name == "server";
          isSuperlab = host.name == "superlab";
        })
      ];

    composite-host-guards =
      { host, ... }:
      let
        isPhone = host.name == "phone-enchilada" || host.name == "phone-fajita";
        isTpm = host.name == "server" || host.name == "handheld";
        isEfi = isTpm || host.name == "main" || host.name == "generic";
        isGraphicArm = isPhone || host.name == "superlab";
        isGraphic = isEfi || isGraphicArm;
        isLive = host.name == "minimal-live" || host.name == "graphical-live";
        isPersistent = (!isLive);
      in
      [
        (den.lib.policy.resolve {
          inherit
            isPhone
            isTpm
            isEfi
            isGraphicArm
            isGraphic
            isLive
            isPersistent
            ;
          isDesktop = isEfi || host.name == "superlab"; # NOT phone
          isVisual = isGraphicArm || host.name == "handheld" || host.name == "main"; # NOT server
          isIntel = host.name == "main" || host.name == "server";
          hasVisualKeyboard = host.name == "handheld" || host.name == "superlab" || host.name == "main"; # (NOT phone AND server)
        })
      ];

    sys-guards =
      { host, ... }:
      [
        (den.lib.policy.resolve {
          isX86 = host.system == "x86_64-linux";
          isArm = host.system == "aarch64-linux";
          isArmv7 = host.system == "armv7l-linux";
          isNixos = host.class == "nixos";
          isDarwin = host.class == "darwin";
        })
      ];

    sysctl-to-boot =
      { host, ... }:
      [
        (den.lib.policy.route {
          fromClass = "sysctl";
          intoClass = host.class;
          path = [
            "boot"
            "kernel"
          ];
        })
      ];
  };

  den.default.includes = with den.policies; [
    host-guards
    sys-guards
    composite-host-guards
    sysctl-to-boot
  ];
}
