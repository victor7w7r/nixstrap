{
  name,
  priority ? 3,
  size ? "100%",
  mountpoint ? null,
  singleOptions ? [ ],
  extraOptions ? [ ],
  volumes ? { },
  isRoot ? false,
}:
let
  mountOptions = [
    "lazytime"
    "noatime"
    "discard=async"
    "compress=zstd:1"
  ]
  ++ extraOptions;

  subvolumes = if isRoot then {
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
  } else volumes;
in
{
  inherit name size priority;
  type = "8300";
  content = {
    inherit mountpoint subvolumes;
    mountOptions = singleOptions;
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "${name}"
    ];
  };
}
