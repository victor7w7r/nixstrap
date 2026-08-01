{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "socktop";
  src = inputs.socktop;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ libdrm ];
})
