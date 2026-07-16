{
  lib,
  pkgs,
  inputs,
  stdenv,
}:
stdenv.mkDerivation (attrs: {
  pname = "repair-usb-disc";
  version = "latest";
  src = inputs.repair-usb-disc;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [
    bash
    ntfs3g
    dosfstools
    exfatprogs
    xfsprogs
    btrfs-progs
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    for exe in "$out/bin/"*; do
      wrapProgram "$exe" \
        --prefix PATH : "${lib.makeBinPath attrs.buildInputs}"
    done
  '';
})
