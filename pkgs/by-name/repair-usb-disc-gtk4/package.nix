{
  lib,
  pkgs,
  repair-usb-disc,
  inputs,
  cache-stdenv,
}:
cache-stdenv.mkDerivation {
  pname = "repair-usb-disc-gtk4";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/linux-stuffs/linux-goodies/-/raw/master/repair-usb-disc-gtk4/distrib/repair-usb-disc-gtk4-0.1-0.tar.gz";
    sha256 = "sha256-nr68FzRf2Wksj0Bun6uCZ8Uj47H7uYECIwHptjFBLPg=";
  };

  nativeBuildInputs = with pkgs; [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = with pkgs; [
    (python3.withPackages (ps: [ ps.pygobject3 ]))
    gtk4
    util-linux
    ntfs3g
    exfatprogs
    dosfstools
    repair-usb-disc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  gappsWrapperArgs = with pkgs; [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      util-linux
      ntfs3g
      exfatprogs
      dosfstools
    ]}"
  ];
}
