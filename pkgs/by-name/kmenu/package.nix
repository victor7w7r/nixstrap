{ pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation (attrs: {
  pname = "kMenu";
  version = "main";

  src = pkgs.fetchFromGitHub {
    owner = "51n7";
    repo = attrs.pname;
    rev = attrs.version;
    sha256 = "sha256-Ium+RmV8zieSqHFZul4MdRZFKPUKmJVCoo2OoLCrwzk=";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids
    mv package $out/share/plasma/plasmoids/org.51n7.kMenu
  '';
})
