{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "zeitfetch";
  cargoHash = "sha256-GM3hY3KY/G1B/ashmjusbnT1tqcP6CdyHyGnaXTskcw=";
  src = inputs.zeitfetch;
})
