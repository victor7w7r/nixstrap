{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "zilch";
  src = inputs.zilch;
  cargoHash = "sha256-M3+66AsLgkfpg8sHvx4vWFLKSS9a8soSxjFMDe8ip1o=";
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
    wrapProgram $out/bin/zilch \
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
