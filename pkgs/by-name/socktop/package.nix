{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "socktop";
  src = inputs.socktop;
  version = "0.1.0";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ libdrm ];
})
