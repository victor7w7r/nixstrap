{ host, ... }:
{
  imports = [
    (import ./boot)
    (import ./system)
    (import ./hardware)
    (import ./networking)
    (import ./security)
    (import ./desktop)
    (import ./dev)
  ]
  ++ (
    if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") then
      [
        (import ./android)
        (import ./misc)
        (import ./multimedia)
        (import ./virt)
      ]
    else
      [ ]
  )
  ++ (if host == "v7w7r-youyeetoox1" then [ (import ./selfhost) ] else [ ]);
}
