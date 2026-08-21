{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "lifecycler";
  src = inputs.lifecycler;
  cargoHash = "sha256-jUcYyp+hMcdgWkdSf3DywSscGff9DpQ1Dt0pgEiP930=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    alsa-lib
    udev
  ];
})
