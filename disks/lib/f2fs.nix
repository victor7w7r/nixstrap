{
  name,
  size ? null,
  mountpoint ? "/",
  priority ? null,
}:
let
  args = (import ./f2fs-args.nix) { inherit name; };
  mountOptions = args.mountOptions;
  extraArgs = args.extraArgs;
in
{
  inherit name size;
  content = {
    type = "filesystem";
    format = "f2fs";
    inherit mountpoint mountOptions extraArgs;
  };
}
// (
  if priority != null then
    {
      inherit priority;
      type = "8300";
    }
  else
    { }
)
