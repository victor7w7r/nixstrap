{ pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "loop";
  version = "HEAD";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo = pname;
    rev = version;
    sha256 = "sha256-0nUZP7PRhsw+BOnDF3E7Mb8qngUVHjFdh8PFgJbDFy0=";
  };

  cargoHash = "sha256-ZKr99Lr+EOSXBpHL4hCwG+5xavJWI3ah/illd15i7g0=";
}
