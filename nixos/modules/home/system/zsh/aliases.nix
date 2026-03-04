{ ... }:
{
  programs.zsh.shellAliases = {
    ssh = "TERM=xterm-256color command ssh";
    _ = "sudo";
    e = "emacs -nw";
    o = "open .";
    t = "btop";
    b = "bat -P --paging=never";
    ff = "find . -type f -name";
    chmox = "chmod +x";
    mv = "mv -iv";
    rm = "rm -rvif";
    cls = "clear && printf '\e[3J'";
    cp = "cp -rvi";
    cdy = "pwd | xclip -i";
    cdp = "cd (xclip -o)";
    cow = "customfortunes | cowsay --bold $(random-opts) --random --super";
    mkdir = "mkdir -pv";
    tarls = "tar -tvf";
    shot = "flameshot gui";
    untar = "tar -xf";
    biggest = "du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh";
    dux = "du -x --max-depth=1 | sort -n";
    dud = "du -d 1 -h";
    duf = "du -sh *";
    grep = "grep -H --color=auto --exclude-dir={.git,.vscode}";
    rscp = "rsyncy -avhE --progress --partial --info=stats2 --inplace --no-i-r --numeric-ids --human-readable";
    rsmv = "rsyncy -avhE --no-compress --progress --remove-source-files --partial --info=stats2 --inplace --no-i-r --numeric-ids --human-readable";
    py = "python3";
    g = "git";
    lg = "lazygit";
    lzd = "lazydocker";
    killn = "killall -q";
    beep = ''echo -e "\a"; sleep 0.1; echo -e "\a"'';
    space = "cat /dev/zero > zero.fill && sync && sleep 1 && sync && rm -f zero.fill";

    timestamp = "date '+%Y-%m-%d %H:%M:%S'";
    datestamp = "date '+%Y-%m-%d'";
    isodate = "date +%Y-%m-%dT%H:%M:%S%z";
    utc = "date -u +%Y-%m-%dT%H:%M:%SZ";
    unixepoch = "date +%s";

    meminfo = "free -m -l -t";
    memhog = "ps -eo pid,ppid,cmd,%mem --sort=-%mem | head";
    cpuhog = "ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head";
    cpuinfo = "lscpu";
    distro = "cat /etc/*-release";
    ports = "netstat -tulanp";

    print-fpath = "for fp in $fpath; do echo $fp; done; unset fp";
    print-path = ''echo $PATH | tr ":" "\n"'';
    print-functions = ''print -l $\{(k)functions[(I)[^_]*]} | sort'';
    myip = "curl icanhazip.com";
    weather = "curl wttr.in";
    weather-short = ''curl "wttr.in?format=3"'';
    cheat = "curl cheat.sh/";
    tinyurl = "curl -s http://tinyurl.com/api-create.php?url=";
    joke = "curl https://icanhazdadjoke.com";
    hackernews = "curl hkkr.in";
    worldinternet = "curl https://status.plaintext.sh/t";
    path = ''echo $PATH | tr ":" "\n" | nl'';

    tmux = "tmux -f ~/.config/tmux/tmux.conf";
    treload = ''tmux source-file ~/.config/tmux/tmux.conf && tmux display-message "TMUX Config Reloaded"'';
    rrr = "ranger";
    nnn = "nnn -e";
    faf = "fastfetch -c $HOME/.config/fastfetch/config.conf";
    top = "htop";
    bmtop = ''btm $([ "$COLOR_SCHEME" = "light" ] && echo "--color default-light")'';
    flatupdate = "flatpak update; flatpak remove --unused";

    update = ''
      brew -v update ; \
      brew upgrade ; \
      brew upgrade --cask --greedy --verbose ; \
      brew upgrade --force-bottle ; \
      brew cleanup ; \
      brew doctor'';

    brewinfo = "brew leaves | xargs brew desc --eval-all";

    l = "eza --icons --git --classify=auto --color --group-directories-first --sort=extension -a";
    ls = "l";
    ll = "l -l --octal-permissions --no-permissions --header --group --created --modified";
    lsa = "ls -aG";
    ldot = "ls -ld .*";

    show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
    hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
    masi = "mas install";
    masl = "mas list";
    maso = "mas outdated";
    mass = "mas search";

    btrfs-snap = "sudo btrfs subvolume snapshot / /snapshots/root_(date +'%Y-%m-%d_%H:%M')";
    me = ''echo $(ifconfig eth0 | grep "inet " | cut -b 9- | cut  -d" " -f2)'';
    e4l = "enum4linux -a";
    h2t = "html2text -style pretty";
    s = "startx";

    reload = ''. "$ZDOTDIR/.zshrc" && echo "Sourced $ZDOTDIR/.zshrc"'';
    colormap = ''for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}$\{(l:3::0:)i}%f " $\{$\{(M)$((i%6)):#3}:+$'\n'}; done'';
    zupdate = "zinit update --parallel 40";
    zselfupdate = "zinit self-update";
    zreset = ''rm -rf "$\{ZSHEXECDIR}/zinit" &>/dev/null && rm -rf "$\{HOME}/.local/share/zinit" &>/dev/null'';
  };
}
