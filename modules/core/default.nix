{ host, ... }:
{
  imports = [
    (import ./kernel)
    (import ./networking)
    (import ./packages)
    (import ./system)
    (import ./desktop)
    (import ./gaming)
  ]
  ++ (if (host != "v7w7r-nixvm") then [ (import ./virt) ] else [ ]);
}
