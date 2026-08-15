{ cache-stdenv, pkgs }:
cache-stdenv.mkDerivation {
  pname = "udefrag";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://web.archive.org/web/20220418235325/https://jp-andre.pagesperso-orange.fr/ultradefrag-5.0.0AB.8.zip";
    sha256 = "sha256-uUI9i7Q0qLb0JwWxidUn7rUM+RtWsV5wPmgxIMDlW4E=";
  };
  patchSrc = pkgs.fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/udefrag.patch?h=udefrag";
    sha256 = "sha256-2+VQyTms8743z9RHkB/ob3EzeIEsMu1NRjihAoXVcng=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];

  buildInputs = with pkgs; [
    ntfs3g
    ncurses
  ];

  prePatch = "cp $patchSrc ./udefrag.patch && patch -p 2 -i udefrag.patch";

  NIX_CFLAGS_COMPILE = [
    "-I${pkgs.ntfs3g}/include/ntfs-3g"
    "-I${pkgs.ncurses.dev}/include"
    "-Wno-implicit-function-declaration"
    "-Wno-int-conversion"
    "-D_GNU_SOURCE"
    "-DLXGC=1"
  ];

  buildPhase = "cd src && make console.a";

  installPhase = ''
    mkdir -p $out/bin
    cp udefrag.l64 $out/bin/udefrag
    chmod +x $out/bin/udefrag
  '';
}
