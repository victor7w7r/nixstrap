{ pkgs, ... }:
{
  environment.defaultPackages =
    with pkgs;
    [
      dos2unix
      catimg
      coreutils-full
      findutils
      fortune
      gnugrep
      gnused
      jump
      hyperfine
      moreutils
      openssh
      p7zip
      readline
      sampler
      sd
      watch
      wget
      wtfutil
      xxh
      xz
      x-cmd
      zlib
    ]
    ++ [
      fd
      fpp
      fsql
      lsd
      ripgrep
      rm-improved
      rnr
      timg
      tre-command
    ]
    ++ [
      cheat
      croc
      progress
      pv
      rsyncy
    ]
    ++ [
      duf
      dust
      gdu
      lsof
      lnav
      mprocs
      ncdu
      pueue
      scrcpy
    ];
}
