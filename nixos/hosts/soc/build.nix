{
  host,
  populateRootCommands,
  persist,
  preBuildCommands,
  boot,
  store,
  postBuildCommands,

  config,
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
  imageName =
    "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  name = imageName;
  nativeBuildInputs = with pkgs; [
    dosfstools
    mtools
    libfaketime
    fakeroot
    libcryptsetup
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
