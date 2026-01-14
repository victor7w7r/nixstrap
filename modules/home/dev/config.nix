{ ... }:
{
  programs = {
    difftastic = {
      enable = true;
      git.enable = true;
      options.background = "dark";
    };
    gitui.enable = true;
    jq.enable = true;
    lazysql.enable = true;
    #meli.enable = true; BUILD
    mods.enable = true;
    visidata.enable = true;
  };
}
