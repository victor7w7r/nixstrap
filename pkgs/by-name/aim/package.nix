{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "aim";
  nativeBuildInputs = with pkgs; [ perl ];
  buildInputs = with pkgs; [ openssl ];
  src = inputs.aim;
})
