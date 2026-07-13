{ pkgs, inputs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "btrfs-data-recovery";
  version = "latest";
  src1 = inputs.btrfs-data-recovery-map;
  src2 = inputs.btrfs-data-recovery-scanner;
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
