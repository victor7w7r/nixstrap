{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      sl
      asciiquarium-transparent
      cmatrix
      tmatrix
      #https://github.com/st3w/neo
      # https://github.com/bartobri/no-more-secrets
      # https://github.com/roberte777/rbonsai
      pipes-rs
      #https://github.com/cxreiff/lifecycler
      lavat
      #https://github.com/gabe565/cli-of-life
      ternimal
      #https://github.com/sachaos/go-life
      # https://github.com/cdkw2/conway-screensaver
      astroterm
      genact
      terminaltexteffects
      #https://github.com/forumplayer/dvdts
      #https://github.com/frostyarchtide/sandscreen
      #https://aur.archlinux.org/packages/termsaver-git
      #https://github.com/nthnd/tuime
      # https://github.com/alemidev/scope-tui
      #https://github.com/Chleba/tui-slides
      # https://github.com/tree-s/ncmatrix
      #dra download -o ~/.local/bin -a George-lewis/DVDBounce --install-file dvdbounce
      #https://crates.io/crates/gof-rs/0.2.1
      #git clone https://github.com/in3rsha/sha256-animation
      #podman run -it docker.io/akiva/bollywood
      #npm i -g chalk-animation
      #https://crates.io/crates/gof-rs/0.2.1
      aalib
      #https://github.com/poetaman/arttime
      cfonts
      toilet
      #https://github.com/orangekame3/paclear

      nbsdgames
      chess-tui
      tty-solitaire
      #https://github.com/ajeetdsouza/clidle
      #https://github.com/shixinhuang99/sxtetris
      #dra download -a -i tom-on-the-internet/cemetery-escape
      cointop
      ticker
      #dra download -a -i maaslalani/pom
      #https://github.com/wheaney/breezy-desktop
      #
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
    ]
  );

}
