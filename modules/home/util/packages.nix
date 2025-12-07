{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      kopia-ui
      morphosis
      pinta
      rnote
      sticky-notes
    ]
  );

  programs = {
    onlyoffice.enable = true;
  };

}
