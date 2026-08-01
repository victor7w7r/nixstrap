{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "kde-thumbnailer-apk";
  version = "latest";
  src = inputs.kde-thumbnailer-apk;
  nativeBuildInputs = with pkgs; [
    cmake
    kdePackages.extra-cmake-modules
    shared-mime-info
  ];

  buildInputs = with pkgs; [
    kdePackages.kio
    libzip
  ];

  dontWrapQtApps = true;
  configurePhase = "cmake -B build -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_INSTALL_LIBDIR=lib";
  buildPhase = "make -C build";
  installPhase = "make -C build install";
}
