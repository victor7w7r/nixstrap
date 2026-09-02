{ disko, lib, ... }:
{
  disko.xfs = {
    call =
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
        ]
        ++ (lib.optionals (logdev != null) [ "logdev=${logdev}" ])
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
          "bigtime=1,crc=1,finobt=1,inobtcount=1,rmapbt=1,reflink=${if isRaid then "0" else "1"}"
          "-l"
          "${lib.optionalString (logdev != null) "logdev=${logdev}"}"
          "${lib.optionalString (logsize != null) ",logsize=${logsize}"}"
          "-L"
          (if name != null then name else nameLvm)
          "-d"
          "agcount=${
            if isRaid || isVmStorage || isSolid then "4" else "2"
          }${if isRaid then ",sunit=1024,swidth=4096" else ",cowextsize=64"}"
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

    lvm =
      {
        mountpoint,
        name,
        size,
        extraOptions ? [ ],
        isRaid ? false,
        logdev ? null,
        num ? 0,
      }:
      {
        "vg${toString num}" = {
          type = "lvm_vg";
          lvs = {
            thinpool = {
              size = "100%";
              lvm_type = "thin-pool";
            };
            "${name}" = disko.xfs.call {
              inherit
                mountpoint
                size
                logdev
                extraOptions
                isRaid
                ;
              nameLvm = name;
              extraSetupDisk = {
                pool = "thinpool";
                lvm_type = "thinlv";
              };
            };
          };
        };
      };
  };
}
