{
  den.aspects.server.services.xrdp.nixos =
    { pkgs, ... }:
    {
      services = {
        fwupd.enable = true;

        xrdp = {
          enable = true;
          defaultWindowManager =
            pkgs.writeShellScript "xrdp-xfce-session" ''
              exec > /tmp/xrdp-debug.log 2>&1
              set -x

              export XDG_SESSION_TYPE=x11
              export XDG_CURRENT_DESKTOP=XFCE
              export DESKTOP_SESSION=xfce
              export GDK_BACKEND=x11
              export QT_QPA_PLATFORM=xcb
              export NIXOS_OZONE_WL=0
              export XDG_RUNTIME_DIR="/run/user/$(id -u)"

              exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.xfce4-session}/bin/startxfce4
            ''
            |> (session: "exec ${session}");
          openFirewall = true;
        };
      };
    };
}
