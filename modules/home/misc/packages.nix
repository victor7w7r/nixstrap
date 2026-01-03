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
}
