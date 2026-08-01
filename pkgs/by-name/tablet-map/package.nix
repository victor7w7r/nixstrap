{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "tablet-map";
  src = inputs.tablet-map;
  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D target/release/tablet_map $out/bin/tablet_map
  '';
})
