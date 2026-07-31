{
  crane,
  inputs,
  pkgs,
}:
(crane.lib.call {
  inherit pkgs;
  pname = "lifecycler";
  source = inputs.lifecycler;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    alsa-lib
    udev
  ];
})
