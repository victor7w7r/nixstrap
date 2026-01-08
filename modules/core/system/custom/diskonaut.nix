{ pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "diskonaut";
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  buildInputs = [ pkgs.openssl ];
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-szDsxkkJRYnQ73iemi/DjArO3Z5kIAEoLoPkToHoRtM=";
  };

  cargoHash = "sha256-Rs9NQRlDv0Vt4NQGYs0jvFnlnlJ+wvgwBA4n1ZZ++io=";
}
