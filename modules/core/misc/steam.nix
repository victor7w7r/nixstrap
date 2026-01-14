{ pkgs, host, ... }:
{
  hardware.steam-hardware.enable = (host != "v7w7r-nixvm" || host != "v7w7r-youyeetoox1");
  programs.steam = {
    enable = (host != "v7w7r-nixvm" || host != "v7w7r-youyeetoox1");
    dedicatedServer.openFirewall = false;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    extraPackages = with pkgs; [
      mangohud
      gamescope
    ];
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };
}
