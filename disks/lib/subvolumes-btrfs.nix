{
  extraOptions ? [ ],
}:
let
  mountOptions = [
    "lazytime"
    "noatime"
    "discard=async"
    "compress=zstd:1"
  ]
  ++ extraOptions;
in
{
  "@" = {
    mountpoint = "/";
    inherit mountOptions;
  };
  "@nix" = {
    mountpoint = "/nix";
    mountOptions = mountOptions ++ [ "noacl" ];
  };
  "@persist" = {
    mountpoint = "/nix/persist";
    inherit mountOptions;
  };
}
