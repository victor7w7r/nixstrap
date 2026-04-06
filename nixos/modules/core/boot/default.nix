{ host, ... }:
{
  imports = [
    (import ./emulation.nix)
    (import ./sysctl.nix)
  ]
  ++ (
    if (host != "v7w7r-opizero2w") then
      [
        (import ./bootloader.nix)
        (import ./persist.nix)
      ]
    else
      [ ]
  );
}
