{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "cargofetch";
  nativeBuildInputs = with pkgs; [
    perl
    pkg-config
  ];
  buildInputs = with pkgs; [ openssl ];
  src = inputs.cargofetch;
})
