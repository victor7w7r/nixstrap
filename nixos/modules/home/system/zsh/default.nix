{ ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        "alias" = "fg=magenta,bold";
        "command" = "fg=cyan";
      };
    };
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
    (import ./options.nix)
    (import ./variables.nix)
    (import ./plugins.nix)
    (import ./init.nix)
  ];
}
