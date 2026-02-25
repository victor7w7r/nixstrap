{
  lib,
  pkgs,
  stdenv,
  ...
}:
let
  modprobedDb = ./modprobed.db;
in
stdenv.mkDerivation {
  name = "kernel-minimal";
  src = pkgs.linux_6_12.src;
  nativeBuildInputs = with pkgs; [
    ncurses
    pkg-config
    bc
    flex
    bison
    perl
  ];
  unpackPhase = "true";
  installPhase = "true";
  buildPhase = ''
    cp -r ${pkgs.linux_6_12.src}/* .
    make defconfig
    export LSMOD=$(mktemp)
    awk '{ print $1, 0, 0 }' ${modprobedDb} > $LSMOD
    yes "" | make localmodconfig
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "scripts/config --module ${k}"))}
    cp .config $out/config
  '';
}
