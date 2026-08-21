{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "aim";
  nativeBuildInputs = with pkgs; [ perl ];
  buildInputs = with pkgs; [ openssl ];
  src = inputs.aim;
})
