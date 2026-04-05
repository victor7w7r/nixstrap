{ lib, ... }:
{
  services = {
    power-profiles-daemon.enable = true;
    pipewire.enable = lib.mkDefault true;
    pulseaudio.enable = lib.mkDefault false;
  };
}
