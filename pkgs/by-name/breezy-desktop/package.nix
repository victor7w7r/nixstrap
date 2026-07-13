{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "breezy-desktop";
  version = "latest";
  src = inputs.breezy-desktop;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/lib/qt6/plugins/kwin/effects/plugins/
    mkdir -p $out/lib/qt6/plugins/plasma/kcms/
    mkdir -p $out/share/applications/
    mkdir -p $out/share/breezy-desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/bin

    touch $out/lib/qt6/plugins/kwin/effects/plugins/breezyfollow.so
    touch $out/lib/qt6/plugins/plasma/kcms/kcm_breezy_kwin_follow.so

    if [ -f ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg ]; then
      cp ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg $out/share/icons/hicolor/scalable/apps/
    fi

    cat > $out/share/applications/kcm_breezy_kwin_follow.desktop << EOF
    [Desktop Entry]
    Name=Breezy KWin Follow
    Comment=Configure Breezy Desktop KWin integration
    Exec=kcmshell6 kcm_breezy_kwin_follow
    Icon=preferences-system-windows
    Type=Application
    X-KDE-ServiceTypes=KCModule
    X-KDE-Library=kcm_breezy_kwin_follow
    X-KDE-ParentApp=kcontrol
    X-KDE-System-Settings-Parent-Category=desktop
    X-KDE-Weight=50
    Categories=Qt;KDE;Settings;
    EOF

    cat > $out/share/applications/com.xronlinux.BreezyDesktop.desktop << EOF
    [Desktop Entry]
    Name=Breezy Desktop
    Comment=XR glasses desktop integration
    Exec=true
    Icon=$out/share/icons/hicolor/scalable/apps/share/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg
    Terminal=false
    Type=Application
    Categories=Utility;
    EOF

    cat > $out/bin/breezy-desktop-kwin-setup << EOF
    #!/bin/sh
    # Enable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled true
    # Start XR driver service
    systemctl --user enable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the setup."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-setup

    cat > $out/bin/breezy-desktop-kwin-uninstall << EOF
    #!/bin/sh
    # Disable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled false
    # Stop XR driver service
    systemctl --user disable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the uninstallation."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-uninstall
  '';
}
