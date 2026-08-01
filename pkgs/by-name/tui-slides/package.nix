{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "tui-slides";
  src = inputs.tui-slides;
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
