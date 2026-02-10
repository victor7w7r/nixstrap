{
  name,
  size ? null,
  mountpoint ? null,
  priority ? null,
  mountOptions ? [ ],
  subvolumes ? { },
}:
{
  inherit name size;
  content = {
    inherit
      mountpoint
      subvolumes
      mountOptions
      ;
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "${name}"
    ];
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
