{ host, ... }:
{
  imports = [
    (import ./boot)
    (import ./system)
    (import ./misc)
    (import ./networking)
    (import ./security)
    (import ./dev)
  ]
  ++ (
    if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") && (host != "v7w7r-opizero2w") then
      [
        (import ./android)
        (import ./multimedia)
      ]
    else
      [ ]
  )
  ++ (if (host != "v7w7r-opizero2w") then [ (import ./desktop) ] else [ ])
  ++ (
    if (host != "v7w7r-opizero2w") || (host != "v7w7r-fajita") then [ (import ./hardware) ] else [ ]
  )
  ++ (if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") then [ (import ./virt) ] else [ ])
  ++ (if host == "v7w7r-youyeetoox1" then [ (import ./selfhost) ] else [ ]);
}
