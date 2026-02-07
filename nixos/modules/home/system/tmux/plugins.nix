''
  set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.tmux/plugins'
  if "test ! -d ~/.tmux/plugins/tpm" \
    "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

  #set -g @plugin 'Morantron/tmux-fingers'
  #set -g @plugin 'ofirgall/tmux-browser'
  #https://github.com/remi/teamocil
  set -g @plugin 'tmux-plugins/tpm'

  set -g @plugin 'wfxr/tmux-fzf-url'
  set -g @plugin 'tmux-plugins/tmux-cowboy'
  set -g @plugin 'danjeltahko/spotify-tmux'
  set -g @plugin 'tmux-plugins/tmux-sidebar'
  set -g @plugin 'nhdaly/tmux-better-mouse-mode'
  set -g @plugin 'jaclu/tmux-menus'
  set -g @plugin 'schasse/tmux-jump'
  set -g @plugin 'rickstaa/tmux-notify'
  set -g @plugin 'sainnhe/tmux-fzf'
  set -g @plugin 'jaclu/tmux-power-zoom'
  set -g @plugin 'omerxx/tmux-floax'
  set -g @plugin 'tmux-plugins/tmux-logging'
  set -g @plugin 'tmux-plugins/tmux-pain-control'
  set -g @plugin 'tmux-plugins/tmux-resurrect'
  set -g @plugin 'tmux-plugins/tmux-continuum'
  set -g @plugin 'MunifTanjim/tmux-suspend'
  set -g @plugin 'omerxx/tmux-sessionx'
  set -g @plugin 'tmux-named-snapshot'

  run -b '~/.tmux/plugins/tpm/tpm'
'';
