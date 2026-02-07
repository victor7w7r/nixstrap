{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    aggressiveResize = true;
    disableConfirmationPrompt = true;
    clock24 = false;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    sensibleOnTop = false;
    shell = ${pkgs.zsh}/bin/zsh;
    extraConfig = ''

    '';
  };
}
