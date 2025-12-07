{ host, ... }:
{
  imports = [
    (import ./kernel)
    (import ./packages)
    (import ./networking)
    #(import ./pentesting)
    (import ./system)
  ]
  ++ (if (host != "vm") then [ (import ./virt) ] else [ ]);
}
