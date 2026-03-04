{ pkgs, ... }:
let
  status = pkgs.writeShellScript "status-ss" (builtins.readFile ./shell/status);
  foreground = pkgs.writeShellScript "fg-ss" (builtins.readFile ./shell/foreground);
  colors = pkgs.writeShellScript "color-sss" (builtins.readFile ./shell/colors);
in
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
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      ${(import ./bindings.nix)}
      ${(import ./config.nix)}
      ${(import ./ui.nix)}
      run ${status}
      run -b ${foreground}
      run -b ${colors}
    '';
  };

  imports = [ (import ./plugins.nix) ];
}
