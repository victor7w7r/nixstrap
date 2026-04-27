{
  name,
  size,
  mountpoint,
  logdev ? null,
  logsize ? null,
  extraOptions ? [ ],
  isRaid ? false,
  isVmStorage ? false,
  isSolid ? false
}:
let
  agcount = if isRaid || isVmStorage || isSolid then "4" else "2";
in
{
  inherit size name;
  content = {
    inherit mountpoint;
    type = "xfs";
    mountOptions = [
      "noatime"
      "nodiratime"
      "lazytime"
      "logbufs=8"
      "logbsize=256k"
    ]
      ++ (if logdev != null then [ "logdev=${logdev}" ] else [ ])
      ++ (if isSolid then [ "discard" ] else [ "largeio" "swalloc" ])
      ++ (if isRaid then [ "sunit=1024" "swidth=4096" "inode64" ] else [ ])
      ++ extraOptions;
    extraArgs = [
      "-d"
      "agcount=${agcount},cowextsize=64${if isRaid then ",sunit=1024,swidth=4096" else ""}"
      "-i"
      "size=512,sparse=1,nrext64=1"
      "-m"
      "bigtime=1,crc=1,finobt=1,inobtcount=1,rmapbt=1,reflink=1"
      "-l"
      "${if logdev != null then "logdev=${logdev}" else ""}${if logsize != null then ",logsize=${logsize}" else ""}"
      "-L"
      name
    ];
  };
}
