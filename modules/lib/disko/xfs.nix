{ lib, ... }:
{
  disko.xfs.call =
    {
      mountpoint,
      name ? null,
      nameLvm ? null,
      size ? null,
      logdev ? null,
      logsize ? null,
      extraOptions ? [ ],
      entireDisk ? false,
      extraSetupDisk ? null,
      isRaid ? false,
      isVmStorage ? false,
      isSolid ? false,
    }:
    {
      type = "filesystem";
      inherit mountpoint;
      format = "xfs";
      mountOptions = [
        "noatime"
        "nodiratime"
        "lazytime"
        "logbufs=8"
        "logbsize=256k"
        (lib.mkIf (logdev != null) "logdev=${logdev}")
      ]
      ++ (lib.optionals isRaid [
        "sunit=1024"
        "swidth=4096"
        "inode64"
      ])
      ++ (
        if isSolid then
          [ "discard" ]
        else
          [
            "largeio"
            "swalloc"
          ]
      )
      ++ extraOptions;

      extraArgs = [
        "-i"
        "size=512,sparse=1,nrext64=1"
        "-m"
        "bigtime=1,crc=1,finobt=1,inobtcount=1,rmapbt=1,reflink=1"
        "-l"
        "${lib.optionalString (logdev != null) "logdev=${logdev}"}"
        "${lib.optionalString (logsize != null) ",logsize=${logsize}"}"
        "-L"
        (if name != null then name else nameLvm)
        "-d"
        "agcount=${
          if isRaid || isVmStorage || isSolid then "4" else "2"
        },cowextsize=64${lib.optionalString isRaid ",sunit=1024,swidth=4096"}"
      ];
    }
    |> (
      content:
      if entireDisk then
        content
      else
        {
          inherit size content;
        }
        // (if name != null then { inherit name; } else { })
        // (if extraSetupDisk != null then extraSetupDisk else { })
    );
}
