{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "socktop";
  version = "latest";
  src = inputs.socktop;
  cargoHash = "sha256-MWy3gv7kqddrkUDyP56EfTWRw1q1wHVt69MYnJCyeQQ=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ libdrm ];
}
