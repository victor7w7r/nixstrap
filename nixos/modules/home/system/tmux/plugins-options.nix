''
  set -g @fzf-url-bind 'u'
  TMUX_FZF_LAUNCH_KEY="C-k"
  set -g @fzf-url-history-limit '2000'
  #-------------------------------------------------------
  set -g @mighty-scroll-interval 3
  #-------------------------------------------------------
  set -g @menus_simple_style_selected 'fg=#414559,bg=#e5c890'
  set -g @menus_simple_style 'bg=#414559'        # @thm_surface_0
  set -g @menus_simple_style_border 'bg=#414559' # @thm_surface_0
  set -g @menus_nav_next '#[fg=colour220]-->'
  set -g @menus_nav_prev '#[fg=colour71]<--'
  set -g @menus_nav_home '#[fg=colour84]<=='
  #-------------------------------------------------------
  set -g @floax-bind 'L'
  set -g @floax-border-color 'purple'
  set -g @floax-text-color '#e6e3d5'
  #-------------------------------------------------------
  set -g @suspend_key 'F5'
  #-------------------------------------------------------
  set -g @sessionx-bind 'space'
  set -g @sessionx-filter-current 'true'
  set -g @sessionx-preview-location 'top'
  set -g @sessionx-preview-ratio '65%'
  set -g @sessionx-window-height '80%'
  set -g @sessionx-window-width '75%'
  set -g @sessionx-tmuxinator-mode 'on'
  set -g @sessionx-bind-window-mode 'alt-w'
  set -g @sessionx-bind-tree-mode 'alt-t'
  set -g @sessionx-bind-new-window 'alt-c'
  set -g @sessionx-bind-rename-session 'alt-r'
  set -g @sessionx-bind-kill-session 'alt-q'
  set -g @sessionx-bind-configuration-path 'alt-e'
  set -g @sessionx-bind-back 'alt-b'
  set -g @sessionx-ls-command 'eza -a --icons --group-directories-first --color always'
  set -g @sessionx-filtered-sessions 'scratch'
  #-------------------------------------------------------
  set -g @open_browser_key 'B'
  #-------------------------------------------------------
  set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
  set -g @scroll-down-exit-copy-mode "off"
''
