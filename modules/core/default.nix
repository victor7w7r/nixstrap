{ host, ... }:
{
  imports = [
    (import ./kernel)
    (import ./packages)
    (import ./networking)
    (import ./plasma)
    #(import ./pentesting)
    (import ./system)
  ]
  ++ (if (host != "v7w7r-nixvm") then [ (import ./virt) ] else [ ]);
}
