{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "lifecycler";
  version = "latest";
  src = inputs.lifecycler;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    alsa-lib
    udev
  ];

  cargoHash = "sha256-jUcYyp+hMcdgWkdSf3DywSscGff9DpQ1Dt0pgEiP930=";
}
