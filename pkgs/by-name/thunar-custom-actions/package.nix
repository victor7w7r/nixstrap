{
  lib,
  inputs,
  pkgs,
  cache-stdenv,
}:
cache-stdenv.mkDerivation {
  pname = "thunar-custom-actions";
  version = "latest";
  src = inputs.thunar-custom-actions;
  nativeBuildInputs = with pkgs; [
    bc
    gettext
    ghostscript
    imagemagick
    gnupg
    makeWrapper
    pandoc
    perl
    su
    m4
    pinentry-gtk2
    xdg-utils
    zenity
  ];

  buildInputs = [ (pkgs.python3.withPackages (ps: [ ps.lxml ])) ];

  postUnpack = ''
    rm -rf source/m4/m4-utils
    cp -r ${inputs.m4-utils} source/m4/m4-utils
    chmod -R +w source/m4/m4-utils
  '';

  configureFlags = [
    "--without-manpages"
    "PASSWDFILE=/etc/passwd"
  ];

  postFixup = with pkgs; ''
    for bin in "$out"/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "${
          lib.makeBinPath [
            bc
            coreutils
            findutils
            ghostscript
            gnupg
            imagemagick
            m4
            perl
            pinentry-gtk2
            util-linux
            xdg-utils
            zenity
          ]
        }"
    done
  '';
}
