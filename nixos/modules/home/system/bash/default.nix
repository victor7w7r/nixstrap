{ lib, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "erasedups" ];
    historyFileSize = 1000000;
    historySize = 10000;
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
    bashrcExtra = lib.mkMerge [
      (import ./functions/bofh.nix)
      (import ./functions/kaomoji.nix)
      (import ./functions/misc.nix)
      (import ./functions/node.nix)
      (import ./functions/quotes.nix)
      (import ./functions/utils.nix)
    ];
  };

  imports = [
    (import ./aliases.nix)
    (import ./exec.nix)
    (import ./plugins.nix)
    (import ./variables.nix)
  ];
}
