{ ... }:
{
  imports = [
    (import ./config)
    (import ./services)
    (import ./systemd)
    (import ./performance)
    (import ./dm)
    (import ./udev)
    (import ./bootlaoder)
  ];
}
