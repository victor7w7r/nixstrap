{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "scope-tui";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/alemidev/scope-tui/releases/download/v0.3.4/scope-tui-v0.3.4-linux-x64-gnu";
    sha256 = "sha256-alW6Q7cxUPVqAkwcHEyuWjMsbqxsrhWxviU5fE3yITo=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $src $out/bin/
    runHook postInstall
  '';
}
