{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "waybar-dunst";
  version = "latest";
  src = inputs.waybar-dunst;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [ python3 ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp waybar-dunst $out/bin/waybar-dunst
    chmod +x $out/bin/waybar-dunst
    wrapProgram $out/bin/waybar-dunst \
      --prefix PYTHONPATH : "${
        pkgs.python3.pkgs.makePythonPath [
          pkgs.python3.pkgs.dbus-fast
          pkgs.python3.pkgs.pygobject3
        ]
      }" \
      --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.python3 ]}"
  '';
}
