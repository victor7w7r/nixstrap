{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "socktop";
  version = "latest";
  src = inputs.socktop;
  cargoHash = "sha256-usaBZ5xIPYKU4Qca8fI8Bg+XcsDUQNiQDdoohXvtu6w=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ libdrm ];
}
