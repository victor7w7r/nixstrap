{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "t2fanrd";
  src = inputs.t2fanrd;
  cargoHash = "sha256-FKQYiaOTZxD95AWD2zbVjENzMAPrFl/rzhwbkAgGbx0=";
  installPhase = "install -m755 -D target/release/t2fanrd $out/bin/t2fanrd";
  buildInputs = with pkgs; [ alsa-lib ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
