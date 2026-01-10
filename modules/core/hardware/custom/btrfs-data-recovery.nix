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
    sha256 = "sha256-Ww5sr1mloEHF3DAx8ae4ytdyDPByNbSnF/otqgzHBiY=";
  };

  src2 = fetchurl {
    url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-scanner";
    sha256 = "sha256-Ww5sr1mloEHF3DAx8ae4ytdyDPByNbSnF/otqgzHBiY=";
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
