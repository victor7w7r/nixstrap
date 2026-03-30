{ config, ... }:
{
  programs.bash.sessionVariables = {
    BASH_SILENCE_DEPRECATION_WARNING = 1;
    BASH_IT = "${config.home.homeDirectory}/.config/bash/bash_it";
    HISTCONTROL = "ignoredups";
    HISTIGNORE = "?:??";
    GIT_HOSTING = "git@git.domain.com";
    IRC_CLIENT = "irssi";
    TODO = "t";

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
    BASH_IT_THEME = "clean";

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

    LESS = ''
      -R \
      --ignore-case \
      --tilde \
      --chop-long-lines \
      --status-column \
      --LONG-PROMPT \
      --jump-target=10 \
      --RAW-CONTROL-CHARS \
      --clear-screen \
      --tabs=4 \
      --shift=5
    '';
    LESSHISTFILE = "-";
    LESSKEYRC = "$HOME/.config/less/lesskey";
    LESSKEY = "$LESSKEYRC.lwc";
    LESS_TERMCAP_md = "\033[01;34m";
    LESS_TERMCAP_me = "\033[0m";
    LESS_TERMCAP_mh = "\033[2m";
    LESS_TERMCAP_mr = "\033[7m";
    LESS_TERMCAP_se = "\033[27;0m";
    LESS_TERMCAP_so = "\033[1;33m";
    LESS_TERMCAP_ue = "\033[24;0m";
    LESS_TERMCAP_us = "\033[4;1;38;5;250m";
  };
}
