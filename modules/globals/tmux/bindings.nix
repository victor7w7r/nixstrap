{ lib, ... }:
{
  den.default.provides.to-users.homeManager.programs.tmux.extraConfig = lib.mkOrder 100 ''
    unbind r
    unbind '"'
    unbind %

    bind r source-file ~/.config/tmux/tmux.conf \; display-message "Recargada la configuración exitosamente"
    bind o run-shell "open #{pane_current_path}"

    bind c new-window -c "#{pane_current_path}"
    bind-key C command-prompt -p "Nombre de la ventana:" "new-window -n '%%'"
    #bind b copy-mode
    bind-key C-u last-window
    bind-key C-r clear-history
    bind-key R command-prompt -I "#W" "rename-session '%%'"
    bind-key Q kill-window
    bind-key q kill-pane
    bind-key M-q kill-session
    bind-key -n Home send-keys "\e[H"
    bind-key -n End send-keys "\e[F"

    #bind-key -T copy-mode-vi v send -X begin-selection
    #if-shell "uname | grep -q Darwin" "bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'"
    #if-shell "uname | grep -q Darwin" "bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'pbcopy'"
    #if-shell "uname | grep -q Linux" "bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -filter -selection primary | xclip -in -selection clipboard > /dev/null'"
    #if-shell "uname | grep -q Linux" "bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'xclip -in -filter -selection primary | xclip -in -selection clipboard > /dev/null'"

    bind-key g new-window -n lazygit -c "#{pane_current_path}" lazygit
  '';
}
