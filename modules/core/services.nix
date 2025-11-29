{ ... }:
{
  services = {
    gvfs.enable = true;
    displayManager.ly.enable = true;
    udisks2.enable = true;
    openssh.enable = true;
    #gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    scx.enable = true;
  };
}