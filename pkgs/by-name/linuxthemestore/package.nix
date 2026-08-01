{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "linuxthemestore";
  src = inputs.linuxthemestore;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ];
})
