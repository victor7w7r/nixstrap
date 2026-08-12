{ pkgs, inputs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "btrfs-data-recovery";
  version = "latest";
  src1 = pkgs.fetchurl {
    url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-recovery-map";
    sha256 = "sha256-dRzKq1c/JMxX25CXIz5xzSszfXm5A24rovZ01b/kZUQ=";
  };
  src2 = pkgs.fetchurl {
    url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-scanner";
    sha256 = "sha256-oV4StV9TPeGEToU9qtKIfyAx2UzTwWLpVutn/FLGMVE=";
  };
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
  buildInputs = with pkgs; [
    ldc
    sqlite
    stdenv.cc.cc.lib
  ];
  autoPatchelfSearchPath = [ "$out/lib" ];
  installPhase = ''
    mkdir -p $out/bin $out/lib
    ln -s ${pkgs.ldc}/lib/libphobos2-ldc-shared.so $out/lib/libphobos2-ldc-shared.so.110
    ln -s ${pkgs.ldc}/lib/libdruntime-ldc-shared.so $out/lib/libdruntime-ldc-shared.so.110
    cp $src1 $out/bin/btrfs-recovery-map
    cp $src2 $out/bin/btrfs-scanner
    chmod +x $out/bin/btrfs-recovery-map
    chmod +x $out/bin/btrfs-scanner
  '';
}
