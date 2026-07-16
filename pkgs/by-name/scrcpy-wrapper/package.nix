{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage (attrs: {
  pname = "scrcpy-wrapper";
  version = "latest";
  src = inputs.scrcpy-wrapper;
  cargoHash = "sha256-o48iriH7rRsi3XM+dhnrs2HbRAKv82RtiEEG2DPSJjo=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    makeWrapper
  ];

  buildInputs = with pkgs; [
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXrandr
    libXi
  ];

  postInstall = ''
    wrapProgram $out/bin/${attrs.pname} \
      --prefix LD_LIBRARY_PATH : "${
        pkgs.lib.makeLibraryPath (
          with pkgs;
          [
            wayland
            libxkbcommon
            libGL
            libX11
            libXcursor
            libXrandr
            libXi
          ]
        )
      }"
  '';
})
