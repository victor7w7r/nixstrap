{ host, ... }:
{
  imports = [
    (import ./system.nix)
    (import ./net.nix)
    (import ./dev.nix)
    (import ./hardware.nix)
    (import ./watchers.nix)
    (import ./files.nix)
    (import ./disks.nix)
    (import ./games.nix)
    (import ./net-clients.nix)
    (import ./fetch.nix)
  ]
  ++ (
    if (host != "vm") || (host != "server") then
      [
        (import ./android.nix)
        (import ./multimedia.nix)
      ]
    else
      [ ]
  );
}
