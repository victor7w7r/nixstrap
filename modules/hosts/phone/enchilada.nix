{ den, phone, ... }:
{
  den = {
    hosts.aarch64-linux.phone-enchilada.users.victor7w7r = { };
    aspects.phone-enchilada = {
      includes = with den.aspects; [
        phone.common

        audio._
        cli._
        dev.ccache
        dev.zed
        dev.tools
        gui._
        misc.comm
        misc.fetch
        pentest._
        zen._

        android
        bluetooth
        kitty
        libvirt
        plasma
        secrets
        victor7w7r
        waydroid
      ];

      nixos = {
        networking.hostName = "v7w7r-enchilada";
        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = 60;
          priority = 100;
        };

        mobile = {
          system.android.device_name = "OnePlus6";
          device = {
            name = "oneplus-enchilada";
            supportLevel = "supported";
            identity.name = "OnePlus 6";
          };
          hardware.screen.height = 2280;
        };
      };
    };
  };
}
