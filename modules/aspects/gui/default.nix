{
  den.aspects.gui.default.nixos =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ evemu ];
      hardware.uinput.enable = true;
      services = {
        gvfs.enable = true;
        xserver.enable = lib.mkForce true;
        keyd = {
          enable = true;
          keyboards.default = {
            ids = [ "*" ];
            settings = {
              main = {
                capslock = "leftcontrol";
              };
            };
          };
        };
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
