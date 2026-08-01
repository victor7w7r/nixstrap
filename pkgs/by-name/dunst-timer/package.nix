{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "dunst-timer";
  version = "latest";

  src = inputs.dunst-timer;

  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [
    python3
    gobject-introspection
  ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp dunst-timer.py $out/bin/dunst-timer
    chmod +x $out/bin/dunst-timer
    wrapProgram $out/bin/dunst-timer \
      --prefix PYTHONPATH : "${
        pkgs.python3.pkgs.makePythonPath [
          pkgs.python3.pkgs.pygobject3
        ]
      }" \
      --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.python3 ]}"
  '';
}
