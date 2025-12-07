{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:

let
  lxtui = rustPlatform.buildRustPackage rec {
    pname = "lxtui";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "FoleyBridge-Solutions";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-szDsxkkJRYnQ73iemi/DjArO3Z5kIAEoLoPkToHoRtM=";
    };

    cargoSha256 = "0000000000000000000000000000000000000000000000000000";

    buildInputs = [ ];

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
