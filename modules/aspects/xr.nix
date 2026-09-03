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
          ExecStart = "${self'.packages.xrlinux}/bin/xrDriver";
          Restart = "always";
          RestartSec = 2;
        };
      };
    };
}
