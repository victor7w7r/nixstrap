{ ... }:
{
  programs.zsh.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GPG_TTY = "$(tty)";
    COLORTERM = "truecolor";
    SHELL = "zsh";
    TERMINAL = "kitty";
    STARSHIP_CACHE = "$HOME/.starship/cache";
    EZA_COLORS = "di=33:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";
    #LS_COLORS = "$(vivid generate catppuccin-mocha)";
    FILTER = "fzf";
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    BAT_THEME = "ansi";
    BAT_PAGER = "";
    PAGER = "bat --plain";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";

    FNM_VERSION_FILE_STRATEGY = "local";
    FNM_LOGLEVEL = "info";
    FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist";
    FNM_COREPACK_ENABLED = "false";
    FNM_RESOLVE_ENGINES = "true";

    FZF_DEFAULT_OPTS = ''
      --height 30% --info=inline
      --color fg:223,bg:235,hl:208,fg+:223,bg+:235,gutter:235,hl+:167,border:237
      --color info:241,prompt:214,pointer:214,marker:167,spinner:241,header:214
    '';

    FZF_DEFAULT_COMMAND = "fd -tf -HL 2> /dev/null";
    FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
    FZF_ALT_C_COMMAND = "fd -td -HLI 2> /dev/null";
    FZF_TMUX = 1;
    FZF_TMUX_HEIGHT = "30%";
    FZF_COMPLETION_TRIGGER = "**";
    FZF_CTRL_T_OPTS = "--no-reverse";
    FZF_CTRL_R_OPTS = "--no-reverse";
    FZF_ALT_C_OPTS = "--no-reverse";
    FZF_COMPLETION_OPTS = "--no-reverse";

    LESS = "--ignore-case --tilde --chop-long-lines --status-column --LONG-PROMPT --jump-target=10 --RAW-CONTROL-CHARS --clear-screen --tabs=4 --shift=5";
    LESSHISTFILE = "-";
    LESS_TERMCAP_md = "\e[01;34m";
    LESS_TERMCAP_me = "\e[0m";
    LESS_TERMCAP_so = "\e[01;33m";
    LESS_TERMCAP_se = "\e[0m";
  };
  /*
    export HOMEBREW_CASK_OPTS="--no-quarantine"
    export HOMEBREW_NO_ENV_HINTS=true
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_UPGRADE=1
    export LDFLAGS="-L$(brew --prefix openssl)/lib"
    export CPPFLAGS="-I$(brew --prefix openssl)/include"
    export CFLAGS="-I$(brew --prefix openssl)/include"
  */
}
