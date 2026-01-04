{ lib, pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "lxtui";
  version = "0.1.1";
  lxtui = rustPlatform.buildRustPackage {

    inherit pname version;
    buildInputs = [ pkgs.openssl ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    src = fetchFromGitHub {
      owner = "FoleyBridge-Solutions";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-szDsxkkJRYnQ73iemi/DjArO3Z5kIAEoLoPkToHoRtM=";
    };

    cargoHash = "sha256-Rs9NQRlDv0Vt4NQGYs0jvFnlnlJ+wvgwBA4n1ZZ++io=";

    meta = with lib; {
      description = "LXD/LXC TUI Manager";
      homepage = "https://github.com/FoleyBridge-Solutions/lxtui";
      license = licenses.mit;
    };
  };
in
{
  environment.systemPackages = [ lxtui ];
}
