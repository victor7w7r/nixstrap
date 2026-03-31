{ pkgs, ... }:
{
  systemd.user = {
    services.random-rename = {
      Unit.Description = "Setup random icon in panels";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "change-script" ''
          TARGET_DIR="/home/victor7w7wr/.cache"
          FILE_NAME="logo.svg"
          [[ -f "$TARGET_DIR/$FILE_NAME" ]] && rm "$TARGET_DIR/$FILE_NAME"
          case $((RANDOM % 4)) in
            0) cp /etc/nixos/nixos/assets/logo-1.svg "$TARGET_DIR/$FILE_NAME"
            1) cp /etc/nixos/nixos/assets/logo-2.svg "$TARGET_DIR/$FILE_NAME"
            2) cp /etc/nixos/nixos/assets/logo-3.svg "$TARGET_DIR/$FILE_NAME"
            3) cp /etc/nixos/nixos/assets/logo-4.svg "$TARGET_DIR/$FILE_NAME"
            4) cp /etc/nixos/nixos/assets/logo-5.svg "$TARGET_DIR/$FILE_NAME"
          esac

          kbuildsycoca6 --noincremental
          #dbus-send --session --dest=org.kde.plasmashell --type=method_call \
          # /MainApplication org.kde.KApplication.reparseConfiguration
        ''}";
      };
    };

    timers.random-rename-timer = {
      Unit.Description = "Timer para el cambio de nombre aleatorio";
      Timer = {
        OnCalendar = "*:0/30";
        RandomizedDelaySec = "1800";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };

  xdg.desktopEntries = {
    "org.kde.dolphin" = {
      name = "Archivos";
      genericName = "Gestor de Archivos";
      exec = "dolphin %u";
      icon = "org.kde.dolphin";
      type = "Application";
      comment = "Gestión de archivos";
      mimeType = "inode/directory";
      categories = [
        "Qt"
        "KDE"
        "System"
        "FileTools"
        "FileManager"
      ];
      settings.Keywords =
        "archivos;gestión de archivos;administración de archivos;exploración de archivos;"
        + "samba;recursos compartidos de red;gestor de archivos;administrador de archivos;"
        + "explorador;buscador;";
    };

    "org.kde.krdc" = {
      name = "Escritorio Remoto";
      genericName = "Cliente de escritorio remoto";
      exec = "krdc -qwindowtitle %c %u";
      icon = "krdc";
      type = "Application";
      comment = "Conectar con RDP o VNC a otro equipo";
      mimeType = "x-scheme-handler/vnc;x-scheme-handler/rdp;application/x-krdc;";
      categories = [
        "Qt"
        "KDE"
        "Network"
        "RemoteAccess"
      ];
    };

    "org.kde.kcalc" = {
      name = "Calc";
      genericName = "Calc";
      exec = "kcalc";
      icon = "accessories-calculator";
      type = "Application";
      comment = "Calculadora que ofrece numerosas funciones matemáticas";
      categories = [
        "Qt"
        "KDE"
        "Utility"
        "Calculator"
      ];
    };

    "org.kde.kcharselect" = {
      name = "Mapa de Caracteres";
      genericName = "Mapa de Caracteres";
      exec = "kcharselect --qwindowtitle %c";
      icon = "accessories-character-map";
      type = "Application";
      comment = "Explorar todos los caracteres unicode";
      categories = [
        "Qt"
        "KDE"
        "Utility"
      ];
    };

    "org.kde.kcolorchooser" = {
      name = "Selector de Color";
      genericName = "Selector de Color";
      exec = "kcolorchooser";
      icon = "kcolorchooser";
      type = "Application";
      comment = "Selector de colores y editor de paleta";
      categories = [
        "Qt"
        "KDE"
        "Graphics"
      ];
    };

    "kitty" = {
      name = "Terminal";
      genericName = "Terminal";
      exec = "kitty";
      icon = "kitty";
      type = "Application";
      comment = "Terminal basado en GPU";
      terminal = false;
      "X-TerminalArgExec" = "--";
      "X-TerminalArgTitle" = "--title";
      "X-TerminalArgAppId" = "--class";
      "X-TerminalArgDir" = "--working-directory";
      "X-TerminalArgHold" = "--hold";
      categories = [
        "System"
        "TerminalEmulator"
      ];
    };
    "vlc" = {
      name = "VLC";
      genericName = "VLC";
      comment = "Lea, capture, emita sus transmisiones multimedia";
      terminal = false;
      icon = "vlc";
      exec = "vlc --started-from-file %U";
      categories = [
        "AudioVideo"
        "Player"
        "Recorder"
      ];
      settings.Keywords = "Player;Capture;DVD;Audio;Video;Server;Broadcast;";
      mimeType = "application/ogg;application/x-ogg;audio/ogg;audio/vorbis;audio/x-vorbis;audio/x-vorbis+ogg;video/ogg;video/x-ogm;video/x-ogm+ogg;video/x-theora+ogg;video/x-theora;audio/x-speex;audio/opus;application/x-flac;audio/flac;audio/x-flac;audio/x-ms-asf;audio/x-ms-asx;audio/x-ms-wax;audio/x-ms-wma;video/x-ms-asf;video/x-ms-asf-plugin;video/x-ms-asx;video/x-ms-wm;video/x-ms-wmv;video/x-ms-wmx;video/x-ms-wvx;video/x-msvideo;audio/x-pn-windows-acm;video/divx;video/msvideo;video/vnd.divx;video/avi;video/x-avi;application/vnd.rn-realmedia;application/vnd.rn-realmedia-vbr;audio/vnd.rn-realaudio;audio/x-pn-realaudio;audio/x-pn-realaudio-plugin;audio/x-real-audio;audio/x-realaudio;video/vnd.rn-realvideo;audio/mpeg;audio/mpg;audio/mp1;audio/mp2;audio/mp3;audio/x-mp1;audio/x-mp2;audio/x-mp3;audio/x-mpeg;audio/x-mpg;video/mp2t;video/mpeg;video/mpeg-system;video/x-mpeg;video/x-mpeg2;video/x-mpeg-system;application/mpeg4-iod;application/mpeg4-muxcodetable;application/x-extension-m4a;application/x-extension-mp4;audio/aac;audio/m4a;audio/mp4;audio/x-m4a;audio/x-aac;video/mp4;video/mp4v-es;video/x-m4v;application/x-quicktime-media-link;application/x-quicktimeplayer;video/quicktime;application/x-matroska;audio/x-matroska;video/x-matroska;video/webm;audio/webm;audio/3gpp;audio/3gpp2;audio/AMR;audio/AMR-WB;video/3gp;video/3gpp;video/3gpp2;x-scheme-handler/mms;x-scheme-handler/mmsh;x-scheme-handler/rtsp;x-scheme-handler/rtp;x-scheme-handler/rtmp;x-scheme-handler/icy;x-scheme-handler/icyx;application/x-cd-image;x-content/video-vcd;x-content/video-svcd;x-content/video-dvd;x-content/audio-cdda;x-content/audio-player;application/ram;application/xspf+xml;audio/mpegurl;audio/x-mpegurl;audio/scpls;audio/x-scpls;text/google-video-pointer;text/x-google-video-pointer;video/vnd.mpegurl;application/vnd.apple.mpegurl;application/vnd.ms-asf;application/vnd.ms-wpl;application/sdp;audio/dv;video/dv;audio/x-aiff;audio/x-pn-aiff;video/x-anim;video/x-nsv;video/fli;video/flv;video/x-flc;video/x-fli;video/x-flv;audio/wav;audio/x-pn-au;audio/x-pn-wav;audio/x-wav;audio/x-adpcm;audio/ac3;audio/eac3;audio/vnd.dts;audio/vnd.dts.hd;audio/vnd.dolby.heaac.1;audio/vnd.dolby.heaac.2;audio/vnd.dolby.mlp;audio/basic;audio/midi;audio/x-ape;audio/x-gsm;audio/x-musepack;audio/x-tta;audio/x-wavpack;audio/x-shorten;application/x-shockwave-flash;application/x-flash-video;misc/ultravox;image/vnd.rn-realpix;audio/x-it;audio/x-mod;audio/x-s3m;audio/x-xm;application/mxf;";
    };
    "onlyoffice-desktopeditors" = {
      name = "Office";
      genericName = "Office";
      comment = "Verificar documentos de Office";
      terminal = false;
      icon = "onlyoffice-desktopeditors";
      exec = "onlyoffice-desktopeditors %U";
      categories = [
        "Utility"
      ];
      settings.Keywords = "Text;Document;OpenDocument Text;Microsoft Word;Microsoft Works;odt;doc;docx;rtf;";
      mimeType = "application/msword;application/msword-template;application/vnd.ms-word.document.macroEnabled.12;application/vnd.ms-word.template.macroEnabled.12;application/vnd.ms-xpsdocument;application/vnd.ms-excel;application/vnd.ms-excel.sheet.macroEnabled.12;application/vnd.ms-excel.sheet.binary.macroEnabled.12;application/vnd.ms-excel.template.macroEnabled.12;application/vnd.ms-powerpoint;application/vnd.ms-powerpoint.presentation.macroEnabled.12;application/vnd.ms-powerpoint.slideshow.macroEnabled.12;application/vnd.ms-powerpoint.template.macroEnabled.12;application/vnd.ms-visio.drawing.main+xml;application/vnd.ms-visio.drawing.macroEnabled.main+xml;application/vnd.ms-visio.stencil.main+xml;application/vnd.ms-visio.stencil.macroEnabled.main+xml;application/vnd.ms-visio.template.main+xml;application/vnd.ms-visio.template.macroEnabled.main+xml;application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.openxmlformats-officedocument.wordprocessingml.template;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.openxmlformats-officedocument.spreadsheetml.template;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/vnd.openxmlformats-officedocument.presentationml.slideshow;application/vnd.openxmlformats-officedocument.presentationml.template;application/vnd.apple.pages;application/vnd.apple.numbers;application/vnd.apple.keynote;application/vnd.oasis.opendocument.text;application/vnd.oasis.opendocument.text-flat-xml;application/vnd.oasis.opendocument.text-template;application/vnd.oasis.opendocument.spreadsheet;application/vnd.oasis.opendocument.spreadsheet-flat-xml;application/vnd.oasis.opendocument.spreadsheet-template;application/vnd.oasis.opendocument.presentation;application/vnd.oasis.opendocument.presentation-flat-xml;application/vnd.oasis.opendocument.presentation-template;application/vnd.oasis.opendocument.graphics;application/vnd.sun.xml.writer;application/vnd.sun.xml.writer.template;application/vnd.sun.xml.calc;application/vnd.sun.xml.impress;application/wps-office.wps;application/wps-office.wpt;application/wps-office.et;application/wps-office.ett;application/wps-office.dps;application/wps-office.dpt;application/x-hwp;application/epub+zip;application/oxps;application/pdf;application/rtf;application/x-fictionbook+xml;image/vnd.djvu;text/csv;text/markdown;text/plain;text/tab-separated-values;x-scheme-handler/oo-office;";
    };
    "virt-manager" = {
      name = "Máquinas Virtuales";
      genericName = "Máquinas Virtuales";
      exec = "virt-manager";
      icon = "virt-manager";
      type = "Application";
      terminal = false;
      comment = "Gestione máquinas virtuales";
      categories = [
        "System"
        "Emulator"
        "GTK"
      ];
      settings.Keywords = "virtualization;libvirt;vm;vmm;qemu;xen;lxc;kvm;";
    };
    "zen-beta" = {
      name = "Zen";
      icon = "zen-browser";
      genericName = "Web Browser";
      exec = "zen-beta --name zen-beta %U ";
      type = "Application";
      terminal = false;
      comment = "Gestione máquinas virtuales";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = "text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https;";
    };
  };
}
