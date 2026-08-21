{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "linuxthemestore";
  src = inputs.linuxthemestore;
  cargoHash = "sha256-nmgxSe+Qs8hXjMd8ENItGkCFuPGzF/Opa33H/kyHcb0=";
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
