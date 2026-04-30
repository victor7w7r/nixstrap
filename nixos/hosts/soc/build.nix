{
  postBuildCommands,
  bootSize,
  persistSize,
  persistLabel,
  storeLabel,
  isHDD,
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
      isHDD
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
    dosfstools
    fakeroot
    xfsprogs
    f2fs-tools
    gnutar
    libfaketime
    mtools
    pv
    systemdUkify
    util-linux
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
