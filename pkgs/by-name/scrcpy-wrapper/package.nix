{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "scrcpy-wrapper";
  src = inputs.scrcpy-wrapper;

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
