{ host, ... }:
{
  imports = [
    (import ./desktop)
    (import ./kernel)
    (import ./packages)
    (import ./networking)
    (import ./system)
  ]
  ++ (if (host != "v7w7r-nixvm") then [ (import ./virt) ] else [ ]);
}
