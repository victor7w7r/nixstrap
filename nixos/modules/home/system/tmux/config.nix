''
  set -ag terminal-overrides ",vt102:Tc"
  set -q -g status-utf8 on
  setw -q -g utf8 on
  set -s copy-command 'wl-copy'
  setw -g alternate-screen on
  setw -g automatic-rename on
  set -g allow-passthrough on
  set -g detach-on-destroy off
  set -g display-time 1000
  set -g xterm-keys on
  set -g lock-after-time 3600
  set -g status-keys vi
  set -g editor emacs
  setw -g pane-base-index 11
  set -g renumber-windows 1
  set -g repeat-time 0
  set -ga update-environment TERM
  set -ga update-environment TERM_PROGRAM
''
