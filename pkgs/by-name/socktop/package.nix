{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "socktop";
  src = inputs.socktop;
  version = "0.1.0";
  cargoHash = "sha256-usaBZ5xIPYKU4Qca8fI8Bg+XcsDUQNiQDdoohXvtu6w=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ libdrm ];
})
