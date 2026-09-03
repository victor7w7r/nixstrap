{
  den.aspects.xr.nixos =
    { pkgs, self', ... }:
    {
      boot.kernelModules = [ "uinput" ];

      environment.systemPackages = with self'.packages; [
        breezy-desktop
        breezy-desktop-kwin
        xrlinux
        pkgs.kdePackages.qtquick3d
      ];

      services.udev.packages = with self'.packages; [ xrlinux ];

      systemd = {
        tmpfiles.rules = [ "r! /dev/shm/xr_driver_state" ];
        user.services.xr-driver = {
          description = "XR user-space driver";
          after = [ "network.target" ];
          wantedBy = [ "default.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${self'.packages.xr-linux}/bin/xrDriver";
            Environment = "LD_LIBRARY_PATH=${self'.packages.xr-linux}/lib";
            Restart = "always";
          };
        };
      };
    };
}
