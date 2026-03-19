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
