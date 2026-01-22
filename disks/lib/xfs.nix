{
  name,
  size,
  label,
  mountpoint,
  postMountHook ? "",
  extraArgs ? [ ],
  mountOptions ? [ ],
  isRAID ? false,
}:
{
  inherit name size;
  content = {
    type = "filesystem";
    format = "xfs";
    inherit mountpoint postMountHook;
    mountOptions = mountOptions ++ [
      "noatime"
      "lazytime"
      "nodiscard"
      "logbsize=256k"
      "inode64"
    ];
    extraArgs =
      extraArgs
      ++ [
        "-f"
        "-m"
        "crc=1,reflink=1"
        "-L"
        label
      ]
      ++ [
        (
          if isRAID then
            [
              "-l"
              "size=128,version=2"
              "-i"
              "size=512"
              "-d"
              "su=64k,sw=2"
            ]
          else
            [
              "-l"
              "size=64"
              "-i"
              "size=256"
              "-d"
              "agcount=32"
            ]
        )
      ];
  };
}
