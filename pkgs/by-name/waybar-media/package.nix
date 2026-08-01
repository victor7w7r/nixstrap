{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "waybar-media";
  version = "latest";
  src = inputs.waybar-media;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [
    python3
    gobject-introspection
  ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp waybar-media.py $out/bin/waybar-media
    chmod +x $out/bin/waybar-media
    wrapProgram $out/bin/waybar-media \
      --prefix PYTHONPATH : "${
        pkgs.python3.pkgs.makePythonPath [
          pkgs.python3.pkgs.psutil
          pkgs.python3.pkgs.pygobject3
          pkgs.python3.pkgs.pydbus
        ]
      }" \
      --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.python3 ]}"
  '';
}
