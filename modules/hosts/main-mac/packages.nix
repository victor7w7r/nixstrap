{
  den.aspects.main-mac.packages.darwin = { pkgs, ... }: {
    environment.defaultPackages = with pkgs; [
      coreutils-full
      findutils
      gnugrep
      gnused
      hyperfine
      moreutils
      readline
      watch
      xxh
      x-cmd
      fd
      fpp
      fsql
      rm-improved
      mprocs
      m-cli
      cocoapods
      colima
      lima
      tailscale
    ];
  };
}
