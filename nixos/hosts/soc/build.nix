{
  postBuildCommands,
  bootSize,
  persistSize,
  persistLabel,
  storeLabel,
  storeFs,
  populateFirmwareCommands,
  closureInfo,
  imageName,
  pkgs,
  stdenv,
  libfaketime,
  fakeroot,
  util-linux,
  f2fs-tools,
  zstd,
  ...
}:
let
  store = import ./store.nix {
    inherit
      storeLabel
      storeFs
      closureInfo
      ;
  };
  boot = import ./boot.nix { inherit bootSize persistSize populateFirmwareCommands; };
  persist = import ./persist.nix { inherit persistSize persistLabel; };
  #nativePkgs = import pkgs.path { system = pkgs.system; };
in
stdenv.mkDerivation {
  name = imageName;
  nativeBuildInputs = with pkgs; [
    bcachefs-tools
    btrfs-progs
    dosfstools
    fakeroot
    f2fs-tools
    gnutar
    libfaketime
    (libguestfs-with-appliance.overrideAttrs (oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or [ ]) ++ [
        "--disable-appliance"
        "--disable-daemon"
      ];
      doInstallCheck = false;
    }))
    mtools
    pv
    systemdUkify
    util-linux
    xfsprogs
    zstd
  ];

  buildCommand = ''
    export bootImg=boot.img

    ${persist}
    ${boot}

    eval $(partx $bootImg -o START,SECTORS --nr 2 --pairs)
    dd conv=notrunc if=./persist.img of=$bootImg seek=$START count=$SECTORS

    ${postBuildCommands}
    ${store}

    zstd -T$NIX_BUILD_CORES --rm $bootImg
    zstd -T$NIX_BUILD_CORES --rm store.img

    mkdir -p $out
    cp -a ./* $out/
  '';
}
