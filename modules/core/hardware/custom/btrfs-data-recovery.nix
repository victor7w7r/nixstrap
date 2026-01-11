{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "fman";
  version = "latest";
  src1 = fetchurl {
    url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-recovery-map";
    sha256 = "sha256-dRzKq1c/JMxX25CXIz5xzSszfXm5A24rovZ01b/kZUQ=";
  };

  src2 = fetchurl {
    url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-scanner";
    sha256 = "sha256-oV4StV9TPeGEToU9qtKIfyAx2UzTwWLpVutn/FLGMVE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src1 $out/bin/btrfs-recovery-map
    cp $src2 $out/bin/btrfs-scanner
    chmod +x $out/bin/btrfs-recovery-map
    chmod +x $out/bin/btrfs-scanner
  '';
}
