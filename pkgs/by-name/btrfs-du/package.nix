{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "btrfs-du";
  version = "latest";
  src = inputs.btrfs-du;
  installPhase = ''
    mkdir -p $out/bin && cp $src/btrfs-du $out/bin/btrfs-du
    chmod +x $out/bin/btrfs-du
  '';
}
