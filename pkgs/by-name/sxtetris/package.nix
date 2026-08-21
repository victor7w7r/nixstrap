{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "sxtetris";
  src = inputs.sxtetris;
  buildInputs = with pkgs; [ alsa-lib ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
