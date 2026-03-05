{ ... }:
{
  programs.zsh = {
    profileExtra = ''
      #typeset -gU path fpath
      if [[ -o interactive && -z "$TMUX" && -z "$SSH_TTY" ]]; then
        if command -v tmux >/dev/null 2>&1 && \
          [[ "$TERM_ROGRAM" != "zed" ]] && \
          [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]] && \
          [ -n "$KONSOLE_DBUS_SESSION" ]; then
           exec tmux -f "$HOME/.config/tmux/tmux.conf" new-session -A -s default
        fi
      fi

      #if [[ -z "$TMUX" && -n "$SSH_TTY" ]]; then
      #    exec tmux attach-session -t default || exec tmux new-session -s default
      #fi

      path=(
        /bin
        /usr/bin
        /usr/local/bin
        /usr/local/sbin
        node_modules/.bin
        "$HOME/.bin"
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "/opt/brew/bin"
        "$HOME/.emacs.d/bin"
        $path
      )
    '';

    loginExtra = ''
      jump -- 'eval "$(jump shell)"'
      source <(cod init $$ zsh)
      systemctl -- 'systemctl --user import-environment PATH'

      if [[ "$OSTYPE" == "darwin"* ]]; then
        if commandexist lolcat; then uname -v | lolcat; else uname -v | lolcat; fi
      else
        if commandexist lolcat; then
          uname -m -n -o -v | lolcat
        elif commandexist meow; then
          uname -m -n -o -v | meow
        else
          uname -m -n -o -v
        fi
      fi

      if commandexist lolcat; then
        echo "Welcome to $(uname)!" | lolcat
      elif commandexist meow; then
        echo "Welcome to $(uname)!" | meow
      else
        echo "Welcome to $(uname)!"
      fi

      if commandexist cowsay && commandexist lolcat; then
        random-quote | cowsay --bold $(random-opts) --random | lolcat
      elif commandexist cowsay && commandexist meow; then
        random-quote | cowsay --bold $(random-opts) --random | meow
      elif commandexist cowsay; then
        random-quote | cowsay --bold $(random-opts) --random
      fi

      zsh_mommy() {
        if [[
          -o interactive &&
          -z "$TMUX" &&
          -x "$(command -v tmux)" &&
          "$TERM_PROGRAM" != "vscode" &&
          -z "$SSH_TTY" ]]; then
          tmux set-environment -g IS_ZSH "1"
        fi
      }

      add-zsh-hook precmd zsh_mommy

      #if commandexist mommy; then
      #  set -o PROMPT_SUBST
      #  RPS1='$(mommy -c $\{HOME}/.config/tmux/mommy.conf -1 -s $?)'
      #fi

      echo -e '\e[5 q'
    '';
  };
}
