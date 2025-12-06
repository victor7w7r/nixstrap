{ ... }:
{
  programs.bat = {
    enable = true;
    #extraPackages
    config = {
      pager = "less -FR";
      theme = "Dracula";
    };
  };
}
