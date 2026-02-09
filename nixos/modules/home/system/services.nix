{ host, ... }:
{
  services = {
    kdeconnect.enable = true;
    pueue.enable = true;
    network-manager-applet.enable = host == "v7w7r-youyeetoox1";
  };
}
