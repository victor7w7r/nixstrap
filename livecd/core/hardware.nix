{ pkgs, lib, ... }:
{
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
        };
      };
    };
    enableAllFirmware = lib.mkForce false;
    firmware = with pkgs; [
      linux-firmware
      rtl8192su-firmware
      rtl8761b-firmware
    ];
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
    opengl.enable = true;
  };
}
