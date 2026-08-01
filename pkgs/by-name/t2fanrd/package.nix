{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "t2fanrd";
  src = inputs.t2fanrd;
  installPhase = "install -m755 -D target/release/t2fanrd $out/bin/t2fanrd";
  buildInputs = with pkgs; [ alsa-lib ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
