{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "tablet-map";
  src = inputs.tablet-map;
  cargoHash = "sha256-8aPasJIznPhBC4jrX+9rX81M9EyDjtmhaMd4NZKxQwc=";
  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D target/release/tablet_map $out/bin/tablet_map
  '';
})
