{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "lifecycler";
  src = inputs.lifecycler;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    alsa-lib
    udev
  ];
})
