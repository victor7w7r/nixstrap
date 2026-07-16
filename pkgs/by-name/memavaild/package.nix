{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "memavaild";
  version = "latest";
  src = inputs.memavaild;
  propagatedBuildInputs = with pkgs; [ python3 ];
  installPhase = ''
    PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units
    substituteInPlace $out/lib/systemd/system/memavaild.service \
      --replace "ExecStart=" "ExecStart=$out"
  '';
}
