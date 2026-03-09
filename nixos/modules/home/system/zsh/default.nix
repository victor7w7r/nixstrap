{ ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=ff00ff,bg=cyan,bold,underline";
    };
    syntaxHighlighting = {
      enable = true;
      styles = {
        "alias" = "fg=magenta,bold";
        "command" = "fg=cyan";
      };
    };
    enableCompletion = true;
    initContent = ''
      autoload -U compinit && compinit -i

      unsetopt BEEP
      unsetopt HIST_BEEP
      unsetopt LIST_BEEP
      unset SSH_ASKPASS
      unset PROMPT_FIRST_TIME

      bindkey '^[[1;2B' down-line-or-history
      bindkey '^[[1;2A' up-line-or-history
      bindkey '^[[1;2C' forward-word
      bindkey '^[[1;2D' backward-word
    '';
    history = {
      extended = true;
      path = "$HOME/.zsh_history";
      save = 10000;
      size = 10000;
      share = true;
    };
    dirHashes = {
      docs = "$HOME/Documentos";
    };
    cdpath = [
      "~/repositories/snowflake"
    ];
  };

  imports = [
    (import ./abbr.nix)
    (import ./aliases.nix)
    (import ./functions)
    (import ./exec.nix)
    (import ./options.nix)
    (import ./plugins.nix)
    (import ./variables.nix)
  ];
}
