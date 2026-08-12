{
  lib,
  pkgs,
  cache-stdenv,
}:
cache-stdenv.mkDerivation {
  pname = "r-linux";
  version = "6.5.191754";
  src = pkgs.fetchurl {
    url = "https://www.r-studio.com/downloads/RLinux6_x64.deb";
    sha256 = "sha256-8QKdTLFFkJlMYFjhJGrTgxC6K6gbrbho8i/9AijxkkY=";
  };
  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    libX11
    libXext
    alsa-lib
    glib
    fontconfig
    freetype

    libSM
    libICE
    libXrender
    libkrb5
    e2fsprogs
  ];

  unpackCmd = "dpkg-deb --fsys-tarfile $src | tar --no-same-permissions --no-same-owner -xvf -";
  dontBuild = true;
  installPhase = ''
        mkdir -p "$out/opt"
        mkdir -p "$out/bin"
        mkdir -p "$out/share/applications"
        mkdir -p "$out/share/pixmaps"
        ls .

        cp -r local/R-Linux "$out/opt/"

        head -n -12 "$out/opt/R-Linux/bin/rlinux" > "$out/opt/R-Linux/bin/rlinux.tmp"

        cat << 'EOF' >> "$out/opt/R-Linux/bin/rlinux.tmp"
    if [ "$EUID" -ne 0 ]; then
        echo "Este programa requiere privilegios de root."
    fi
    exec "$out/opt/R-Linux/bin/R-Linux" "$@"
    EOF

        mv "$out/opt/R-Linux/bin/rlinux.tmp" "$out/opt/R-Linux/bin/rlinux"
        chmod +x "$out/opt/R-Linux/bin/rlinux"

        substituteInPlace "$out/opt/R-Linux/bin/rlinux" \
          --replace "/usr/local" "$out/opt"

        ln -s "$out/opt/R-Linux/bin/rlinux" "$out/bin/rlinux"
        cp "$out/opt/R-Linux/share/logo_48.png" "$out/share/pixmaps/rtt-rlinux.png"
        substitute "$out/opt/R-Linux/share/rtt-rlinux.desktop" "$out/share/applications/rtt-rlinux.desktop" \
          --replace "/usr/local" "$out/opt"
  '';

  postFixup = ''
    wrapProgram "$out/bin/rlinux" \
      --prefix PATH : "${lib.makeBinPath [ pkgs.xhost ]}"
  '';
}
