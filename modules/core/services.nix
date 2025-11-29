{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    cockpit.enable = true;
    udisks2.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    dbus.enable = true;
    #preload.enable = true;
    fstrim.enable = true;
    scx.enable = true;
    kmscon = {
      enable = true;
      hwRender = false;
      fonts = [
        {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        }
      ];
      extraConfig = ''
        font-size=9
        sb-size=10000
        palette=custom
        palette-background=30, 30, 46
      '';
    };
  };
}