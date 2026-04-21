{
  populateRootCommands,
  persist,
  preBuildCommands,
  boot,
  store,
  postBuildCommands,

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

in
stdenv.mkDerivation {
  name = imageName;
  nativeBuildInputs = with pkgs; [
    dosfstools
    mtools
    libfaketime
    fakeroot
    util-linux
    f2fs-tools
    zstd
  ];

  buildCommand = ''
    export bootImg=$out/${imageName}.img
    export storeImg=$out/store-${imageName}.img
    (
      mkdir -p ./files
      ${populateRootCommands}
    )

    ${persist}
    ${preBuildCommands}
    ${boot}

    eval $(partx $bootImg -o START,SECTORS --nr 2 --pairs)
    dd conv=notrunc if=./persist.img of=$bootImg seek=$START count=$SECTORS

    ${store}
    ${postBuildCommands}

    zstd -T$NIX_BUILD_CORES --rm $bootImg
    zstd -T$NIX_BUILD_CORES --rm $storeImg
  '';
}
