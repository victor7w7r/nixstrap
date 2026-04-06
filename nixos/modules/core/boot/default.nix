{ host, ... }:
{
  imports = [
    (import ./emulation.nix)
    (import ./kernel.nix)
    (import ./sysctl.nix)
    (import ./persist.nix)
  ]
  ++ (
    if (host != "v7w7r-opizero2w") then
      [
        (import ./bootloader.nix)
      ]
    else
      [ ]
  );
}
