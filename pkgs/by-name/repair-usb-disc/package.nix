{
  lib,
  pkgs,
  cache-stdenv,
}:
cache-stdenv.mkDerivation (attrs: {
  pname = "repair-usb-disc";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/linux-stuffs/linux-goodies/-/raw/master/repair-usb-disc/distrib/repair-usb-disc-0.1-0.tar.gz";
    sha256 = "sha256-hSEmrF2iSCW4whZIXSmk0BClG8S/j4MhTm7K2eeu+UU=";
  };
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
