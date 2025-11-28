{ ... }:
{
  services = {
    gvfs.enable = true;
    displayManager.ly.enable = true;
    udisks2.enable = true;
    #gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    globalprotect.enable = true;
    scx.enable = true;
  };
}