{
  name,
  priority,
  size ? null,
  mountpoint ? "/",
}:
let
  args = (import ./f2fs-args.nix) { inherit name; };
  mountOptions = args.mountOptions;
  extraArgs = args.extraArgs;
in
{
  inherit name size priority;
  type = "8300";
  content = {
    type = "filesystem";
    format = "f2fs";
    inherit
      mountpoint
      mountOptions
      extraArgs
      ;
  };
}
