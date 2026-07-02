{
  den.aspects.xr.nixos =
    { self', ... }:
    {
      boot.kernelModules = [ "uinput" ];

      environment.systemPackages = with self'.packages; [
        breezy-desktop
        xrlinux
      ];

      services.udev.packages = with self'.packages; [ xrlinux ];

      systemd.user.services.xr-driver = {
        description = "XR user-space driver (Rayneo / XREAL / Viture / Rokid)";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          #ExecStartPre = "${pkgs.coreutils}/bin/install -Dm644 ${../../../../dotfiles/default/xr_driver/config.ini} %h/.config/xr_driver/config.ini";
          ExecStart = "${self'.packages.xrlinux}/bin/xrDriver";
          Restart = "always";
          RestartSec = 2;
        };
      };
    };
}
