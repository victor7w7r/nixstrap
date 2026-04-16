{
  pkgs,
  system,
  host,
  ...
}:
{
  imports = [
    ./kernel.nix
    ./sysctl.nix
    ./persist.nix
  ]
  ++ (
    if (host != "v7w7r-opizero2w" && host != "v7w7r-fajita") then
      [
        ./bootloader.nix
      ]
    else
      [ ]
  )
  ++ (if (system == "x86_64-linux") then [ ./emulation.nix ] else [ ]);
}
