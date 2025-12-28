{
  stdenv,
  fetchFromGitHub,
  kdePackages,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kzones";
  version = "v0.9.1";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xqTQiL+7T6p+Y86eC5InAk6waYoM82iFoLflkN6/dG8=";
  };

  nativeBuildInputs = [
    kdePackages.kpackage
    zip
  ];
  buildInputs = [ kdePackages.kwin ];
  dontWrapQtApps = true;

  buildFlags = [ "build" ];

  installPhase = ''
    runHook preInstall
    kpackagetool6 --type=KWin/Script --install=kzones.kwinscript --packageroot=$out/share/kwin/scripts
    runHook postInstall
  '';
})
