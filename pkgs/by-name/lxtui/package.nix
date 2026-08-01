{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "lxtui";
  buildInputs = with pkgs; [ openssl ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  src = inputs.lxtui;
})
