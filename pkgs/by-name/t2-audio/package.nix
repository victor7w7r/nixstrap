{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "t2-audio";
  version = "latest";
  src = inputs.t2-audio;
  dontBuild = true;
  postPatch = ''
    substituteInPlace files/*.rules --replace "/usr/bin/sed" "${pkgs.gnused}/bin/sed"
  '';
  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    mkdir -p $out/share/apple-t2-better-audio
    cp files/*.rules $out/lib/udev/rules.d/
    cp -r files $out/share/apple-t2-better-audio/files
  '';
}
