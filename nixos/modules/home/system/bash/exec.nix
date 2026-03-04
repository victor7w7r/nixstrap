{ ... }:
{
  programs.bash = {
    profileExtra = ''
      if [[ $- == *i* ]] && \
        [[ -z "$TMUX" ]] && \
        command -v tmux >/dev/null 2>&1 && \
        [[ "$TERM_PROGRAM" != "vscode" ]] && \
        [[ -z "$SSH_TTY" ]]; then
          exec tmux -f "$HOME/.config/tmux/tmux.conf"
      fi

      paths=(
        /bin
        /usr/bin
        /usr/local/bin
        /usr/local/sbin
        node_modules/.bin
        "$HOME/.bin"
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "$HOME/.venv/bin"
      )

      for p in "$\{paths[@]}"; do if [ -d "$p" ]; then PATH="$p:$PATH"; fi; done
      export PATH
    '';

    initExtra = ''
      ${import ./functions}
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
        random-quote | cowsay --bold "$(random-opts)" --random | lolcat
      elif commandexist cowsay && commandexist meow; then
        random-quote | cowsay --bold "$(random-opts)" --random | meow
      elif commandexist cowsay; then
        random-quote | cowsay --bold "$(random-opts)" --random
      fi

      post() {
        local last_exit=$1

        if [[ $- == *i* ]] && \
          [[ -z "$TMUX" ]] && \
          command -v tmux >/dev/null 2>&1 && \
          [[ "$TERM_PROGRAM" != "vscode" ]] && \
          [[ -z "$SSH_TTY" ]]; then
          tmux set-environment -g LAST_EXIT "$last_exit"
          tmux set-environment -g LAST_CMD_TS "$(date +%s%N)"
        fi
      }

      PROMPT_COMMAND='post $?'

      #set -l toon (random choice {default,bud-frogs,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader})
      #fortune -s | cowsay -f $toon | lolcat
      #[[ $\{BLE_VERSION-} ]] && ble-attach
    '';
  };
}
