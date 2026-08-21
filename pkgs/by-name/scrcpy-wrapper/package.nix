{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "scrcpy-wrapper";
  src = inputs.scrcpy-wrapper;
  cargoHash = "sha256-o48iriH7rRsi3XM+dhnrs2HbRAKv82RtiEEG2DPSJjo=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/scrcpy-wrapper \
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

  buildInputs = with pkgs; [
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXrandr
    libXi
  ];
})
