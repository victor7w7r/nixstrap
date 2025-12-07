{ host, ... }:
{
  imports = [
    (import ./system)
    (import ./net)
    (import ./dev)
    (import ./hardware)
    (import ./watchers)
    (import ./files)
    (import ./disks)
    (import ./games)
    (import ./net-clients)
    (import ./fetch)
  ]
  ++ (
    if (host != "vm") || (host != "server") then
      [
        (import ./android)
        (import ./multimedia)
      ]
    else
      [ ]
  );
}
