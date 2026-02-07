''
  set -g visual-bell off
  set -g visual-activity on
  set -g visual-silence on
  setw -g monitor-activity on

  setw -g clock-mode-colour colour141
  set -g clock-mode-style 12
  set -g status-position top
  set -g status-interval 1
  set -g status-left-length 130  #100
  set -g status-right-length 140 #100
  set -g status-justify left
  set -g window-style fg=#e6e3d5

  set -g message-style 'fg=#cdd6f4 bg=#5a6dcc'
  setw -g mode-style 'fg=#212121 bg=#5a6dcc'
  set -g pane-border-style "fg=#45475a"
  set -g pane-active-border-style "fg=#5a6dcc"
  set -g status-style "bg=default,fg=#cdd6f4"

  set -g status-left "#[bg=#313244,fg=#e4cfff]#[bg=#e4cfff,fg=#313244]#{?client_prefix,#[bg=#89dceb],} #{?client_prefix, PREFIX,#{?#{==:#{pane_mode},copy-mode},󰆏 COPY, IDLE}} #[fg=#e4cfff,bg=default]#{?client_prefix,#[fg=#89dceb],}"
  set -g status-right-length 250
  set -g status-right ""

  setw -g window-status-format "#[fg=#cdd6f4]#[bg=default] #I #W"
  setw -g window-status-current-format "#[fg=#5a6dcc,bg=default]#[fg=#cdd6f4,bg=#5a6dcc] #I #W #[fg=#5a6dcc,bg=default]"
  setw -g window-status-format "#[fg=#cdd6f4]#[bg=default] #I #W"
  setw -g window-status-activity-style "bold"
  setw -g window-status-bell-style "bold"
  setw -g window-status-activity-style "bold"
''
