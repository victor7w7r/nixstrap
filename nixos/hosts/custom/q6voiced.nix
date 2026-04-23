{
  pkgs,
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "q6voiced";
  version = "unstable-2022-07-08";
  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "q6voiced";
    rev = "736138bfc9f7b455a96679e2d67fd922a8f16464";
    hash = "sha256-7k5saedIALHlsFHalStqzKrqAyFKx0ZN9FhLTdxAmf4=";
  };
  buildInputs = with pkgs; [
    dbus
    tinyalsa
  ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildPhase = "cc $(pkg-config --cflags --libs dbus-1) -ltinyalsa -o q6voiced q6voiced.c";
  installPhase = ''install -m555 -Dt "$out/bin" q6voiced'';
  meta.license = lib.licenses.mit;
}
