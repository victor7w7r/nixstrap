{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "linuxthemestore";
  version = "latest";
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
  cargoHash = "sha256-nmgxSe+Qs8hXjMd8ENItGkCFuPGzF/Opa33H/kyHcb0=";
}
