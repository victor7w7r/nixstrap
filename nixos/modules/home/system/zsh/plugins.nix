{ pkgs, ... }:
{
  programs.zsh = {
    /*
      OMZL::compfix.zsh \
      OMZL::completion.zsh \
      OMZL::correction.zsh \
      OMZL::directories.zsh \
      OMZL::git.zsh \
      OMZL::grep.zsh \
      OMZL::key-bindings.zsh \
      OMZL::spectrum.zsh \
      has'cod' dim-an/cod \
      bigH/git-fuzzy
      Green-m/msfvenom-zsh-completion
      wehlando/efibootmgr-zsh-completion
      "3v1n0/zsh-bash-completions-fallback"
      #ytakahashi/igit (wait)
    */
    plugins = [
      {
        name = "zsh-defer";
        src = "${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "zsh-clipboard";
        src = "${pkgs.zsh-clipboard}/share/zsh/plugins/clipboard/zsh-clipboard.plugin.zsh";
      }
      {
        name = "zsh-shift-select";
        file = "zsh-shift-select.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "";
          repo = "zsh-shift-select";
          rev = "master";
          sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
        };
      }
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "you-should-use";
        inherit (pkgs.zsh-you-should-use) src;
      }
      {
        name = "wd";
        src = pkgs.zsh-wd;
        file = "share/wd/wd.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "autopair";
        inherit (pkgs.zsh-autopair) src;
        file = "zsh-autopair.plugin.zsh";
      }
      {
        name = "bd";
        src = "${pkgs.zsh-bd}/share/zsh-bd/bd.plugin.zsh";
      }
      {
        name = "zsh-histdb";
        src = "${pkgs.local.zsh-histdb}/share/zsh-histdb";
      }
      {
        name = "zsh-forgit";
        src = "${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "zsh-fzf-history-search";
        src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
      {
        name = "zhooks";
        src = "${pkgs.zsh-zhooks}/share/zsh/zhooks";
      }
      {
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "zsh-navigation-tools";
        src = pkgs.zsh-navigation-tools;
      }
      {
        name = "zsh-autosuggestions-abbreviations-strategy";
        src = pkgs.zsh-autosuggestions-abbreviations-strategy;
      }
      {
        name = "zsh-history-search-multi-word";
        src = "${pkgs.zsh-history-search-multi-word}/share/zsh/zsh-history-search-multi-word/history-search-multi-word.plugin.zsh";
      }
      {
        name = "nix-zsh-completions";
        src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
    ];
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "jirutka/zsh-shift-select"
        "Bhupesh-V/ugit"
        "Schroefdop/git-branches"
        "lainiwa/ph-marks"
        "unixorn/git-extra-commands"
      ];
    };
    oh-my-zsh.plugins = [
      "tmux"
      "aliases"
      "alias-finder"
      "archlinux"
      "autojump"
      "bgnotify"
      "bun"
      "colored-man-pages"
      "command-not-found"
      "podman"
      "eza"
      "extract"
      "fnm"
      "fzf"
      "git"
      "git-commit"
      "lol"
      "python"
      "pyenv"
      "rsync"
      "rust"
      "ssh"
      "systemd"
      "tailscale"
      "thefuck"
      "tldr"
      "wakeonlan"
      "web-search"
      "zoxide"
      "zsh-interactive-cd"
    ];
  };
}
