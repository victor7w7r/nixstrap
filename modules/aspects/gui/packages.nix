{
  den.aspects.gui.packages.nixos =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        evemu
        libinput
        keyd
      ];
      hardware.uinput.enable = true;
      services = {
        gvfs.enable = true;
        xserver.enable = lib.mkForce true;
        libinput = {
          enable = true;
          mouse.accelProfile = "flat";
          touchpad = {
            naturalScrolling = true;
            accelProfile = "flat";
            tapping = true;
            accelSpeed = "0.75";
          };
        };
      };
    };
}
