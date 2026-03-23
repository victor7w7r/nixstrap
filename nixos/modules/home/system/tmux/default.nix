{ pkgs, ... }:
let
  status = pkgs.callPackage ./shell/status.nix { };
  foreground = pkgs.callPackage ./shell/foreground.nix { };
  colors = pkgs.callPackage ./shell/colors.nix { };
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
