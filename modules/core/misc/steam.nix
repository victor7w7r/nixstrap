{ pkgs, host, ... }:
{
  programs.steam = {
    enable = (host != "v7w7r-nixvm" || host != "v7w7r-youyeetoox1");
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    protontricks.enable = true;
  };
}
