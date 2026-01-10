{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      asciiquarium-transparent
      astroterm
      cmatrix
      genact
      lavat
      pipes-rs
      sl
      terminaltexteffects
      ternimal
      tmatrix
    ]
    ++ [
      aalib
      cfonts
      toilet
    ]
    ++ [
      chess-tui
      nbsdgames
      tty-solitaire
    ]
    ++ [
      cointop
      ticker
      (pkgs.callPackage ./custom/cli-of-life.nix { })
      (pkgs.callPackage ./custom/cemetery-escape.nix { })
      (pkgs.callPackage ./custom/clidle.nix { })
      (pkgs.callPackage ./custom/cowsay.nix { })
      (pkgs.callPackage ./custom/dvdbounce.nix { })
      (pkgs.callPackage ./custom/go-life.nix { })
      (pkgs.callPackage ./custom/neo.nix { })
      (pkgs.callPackage ./custom/paclear.nix { })
      (pkgs.callPackage ./custom/sandscreen.nix { })
      (pkgs.callPackage ./custom/scope-tui.nix { })
      (pkgs.callPackage ./custom/sxtetris.nix { })

      #https://github.com/bartobri/no-more-secrets
      #https://github.com/roberte777/rbonsai
      #https://github.com/cxreiff/lifecycler
      #https://github.com/roberte777/rbonsai
      #https://github.com/cdkw2/conway-screensaver
      #https://github.com/forumplayer/dvdts
      #https://aur.archlinux.org/packages/termsaver-git
      #https://github.com/nthnd/tuime
      #https://github.com/Chleba/tui-slides
      #https://github.com/tree-s/ncmatrix
      #https://github.com/omagdy7/gof-rs
      #https://github.com/in3rsha/sha256-animation
      #podman run -it docker.io/akiva/bollywood
      #npm i -g chalk-animation
      #https://github.com/poetaman/arttime
      #dra download -a -i maaslalani/pom
      #https://github.com/wheaney/breezy-desktop

      /*
         fortune-mod-anarchism fortune-mod-darkknight fortune-mod-dhammapada \
        	fortune-mod-anti-jokes-git fortune-mod-archlinux fortune-mod-billwurtz \
        	fortune-mod-bofh-excuses fortune-mod-calvin fortune-mod-canada-nctr \
        	fortune-mod-confucius fortune-mod-cybersuntzu fortune-mod-doctorwho-classic-series \
        	fortune-mod-doctorwho-new-series fortune-mod-es fortune-mod-futurama \
        	fortune-mod-g-git fortune-mod-helluva fortune-mod-husse \
        	fortune-mod-issa-haiku fortune-mod-leftism-git fortune-mod-limericks \
        	fortune-mod-matrix fortune-mod-mlp fortune-mod-portal-game \
        	fortune-mod-protolol-git fortune-mod-question-answer-jokes fortune-mod-starwars \
        	fortune-mod-sw fortune-mod-vimtips fortune-mod-yiddish fortune-mod-off --needed --noconfirm
      */
    ];
}
