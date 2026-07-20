{ lib, ... }:
{
  den.default.provides.to-users.homeManager.programs.tmux.extraConfig = lib.mkOrder 200 ''
    set -ga terminal-overrides ",xterm-256color:Tc,xterm-kitty:Tc,kmscon:Tc,vt100:Tc,vt102:Tc"
    set -s copy-command 'wl-copy'
    setw -g alternate-screen on
    setw -g automatic-rename on
    set -g allow-passthrough on
    set -g detach-on-destroy off
    set -g display-time 1000
    set -g xterm-keys on
    set -g lock-after-time 3600
    set -g editor vim
    set -g renumber-windows 1
    set -g repeat-time 0
    set -ga update-environment TERM
    set -ga update-environment TERM_PROGRAM
  '';
}
