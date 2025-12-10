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
  ++ (if (host != "vm") then [ (import ./virt) ] else [ ]);
}
