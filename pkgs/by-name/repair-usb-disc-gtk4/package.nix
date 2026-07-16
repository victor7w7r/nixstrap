{
  lib,
  pkgs,
  repair-usb-disc,
  inputs,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "repair-usb-disc-gtk4";
  version = "latest";
  src = inputs.repair-usb-disc-gtk4;

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
