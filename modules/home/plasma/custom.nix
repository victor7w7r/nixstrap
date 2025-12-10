{
  pkgs,
  lib,
  pkg-config,
  ...
}:

# nix-env -iA nixpkgs.nix-prefetch-github
# git ls-remote https://github.com/realmazharhussain/appimage-thumbnailer
# nix-prefetch-github realmazharhussain appimage-thumbnailer --rev d0f4a494604724429f0c3396f179b44a09fe2b8f --fetch-submodules
# lib.fakeSha256;

let
  appimage-thumbnailer = pkgs.stdenv.mkDerivation {
    pname = "appimage-thumbnailer";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "realmazharhussain";
      repo = "appimage-thumbnailer";
      rev = "HEAD";
      sha256 = "sha256-Y7s9qdJIJbUqEP0/6qlTPOtE3efRqL1bx66MJIPgRN4=";
    };

    buildInputs = [
      pkgs.bash
      pkgs.imagemagick
    ];

    installPhase = ''
      mkdir -p $out/bin $out/profiles
      export PREFIX=$out
      export DESTDIR=""
      chmod +x install.sh
      ./install.sh
    '';
  };

  kf6-servicemenus-rootactions = pkgs.stdenv.mkDerivation {
    pname = "kf6-servicemenus-rootactions";
    version = "1.0.0";
    src = pkgs.fetchFromGitLab {
      owner = "stefanwimmer128";
      repo = "kf6-servicemenus-rootactions";
      rev = "HEAD";
      sha256 = lib.fakeSha256;
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      kdePackages.dolphin
      kdePackages.kdialog
      imagemagick
      perl
      polkit
    ];

    configurePhase = "./configure --prefix=$out";
    buildPhase = "make";
    installPhase = "make install";
  };

  jar-thumbnailer = pkgs.stdenv.mkDerivation {
    pname = "jar-thumbnailer";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "realmazharhussain";
      repo = "jar-thumbnailer";
      rev = "HEAD";
      sha256 = lib.fakeSha256;
    };

    buildInputs = with pkgs; [
      bash
      unzip
      coreutils
      gnused
    ];

    installPhase = ''
      export PREFIX=$out
      export DESTDIR=""
      chmod +x install.sh
      ./install.sh
    '';
  };

  ffmpeg-audio-thumbnailer = pkgs.stdenv.mkDerivation {
    pname = "ffmpeg-audio-thumbnailer";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "saltedcoffii";
      repo = "ffmpeg-audio-thumbnailer";
      rev = "HEAD";
      sha256 = lib.fakeSha256;
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkg-config
    ];

    buildInputs = with pkgs; [ kdePackages.ffmpeg ];

    buildPhase = "make";
    installPhase = "export PREFIX=$out; make install";
  };

  kde-thumbnailer-apk = pkgs.stdenv.mkDerivation {
    pname = "kde-thumbnailer-apk";
    version = "1.0.0";
    src = pkgs.fetchFromGitLab {
      owner = "z3ntu";
      repo = "kde-thumbnailer-apk";
      rev = "HEAD";
      sha256 = lib.fakeSha256;
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      kdePackages.kio
      libzip
    ];

    configurePhase = "cmake -B build -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_INSTALL_LIBDIR=lib";
    buildPhase = "make -C build";
    installPhase = "make -C build install";
  };

  /*
    dolphin-quick-view = pkgs.stdenv.mkDerivation {
    pname = "kde-thumbnailer-apk";
    version = "1.0.0";
    src = pkgs.fetchFromGitLab {
      owner = "z3ntu";
      repo = "kde-thumbnailer-apk";
      rev = "HEAD";
      sha256 = lib.fakeSha256;
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      (python312.withPackages (ps: [
        ps.pyside6
      ]))
      xclip
      wl-clipboard
      gnused
    ];

    configurePhase = "cmake -B build -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_INSTALL_LIBDIR=lib";
    buildPhase = "make -C build";
    installPhase = "make -C build install";
    };
  */

in
{
  home.packages = [
    appimage-thumbnailer
    kf6-servicemenus-rootactions
    jar-thumbnailer
    kde-thumbnailer-apk
    ffmpeg-audio-thumbnailer
  ];
}
