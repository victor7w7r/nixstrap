{ ... }:
{
  programs.zsh = {
    loginExtra = ''
      #typeset -gU path fpath
      if [[ -o interactive && -z "$TMUX" && -z "$SSH_TTY" ]]; then
        if command -v tmux >/dev/null 2>&1 && [[ "$TERM_PROGRAM" != "zed" ]] && \
          [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
           exec tmux new-session -A -s default
        fi
      fi

      if [[ "$TERM_PROGRAM" == "zed" ]]; then
        export EDITOR="zed"
        export VISUAL="zed --wait"
      fi

      path=(
        /bin
        node_modules/.bin
        "$HOME/.bin"
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "/opt/brew/bin"
        "$HOME/.emacs.d/bin"
        $path
      )

      #jump -- 'eval "$(jump shell)"'
      source <(cod init $$ zsh)

      if [[ "$OSTYPE" == "darwin"* ]]; then
        if commandexist clolcat; then uname -v | clolcat; else uname -v | clolcat; fi
      else
        if commandexist clolcat; then
        uname -m -n -o -v | clolcat
        elif commandexist meow; then
          uname -m -n -o -v | meow
        else
          uname -m -n -o -v
        fi
      fi

      if commandexist clolcat; then
        echo "Welcome to $(uname)!" | clolcat
      elif commandexist meow; then
        echo "Welcome to $(uname)!" | meow
      else
        echo "Welcome to $(uname)!"
      fi

      if commandexist cowsay && commandexist clolcat; then
        random-quote | cowsay --bold $(random-opts) --random | clolcat
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

      #add-zsh-hook precmd zsh_mommy

      #if commandexist mommy; then
      #  set -o PROMPT_SUBST
      #  RPS1='$(mommy -c ''${HOME}/.config/tmux/mommy.conf -1 -s $?)'
      #fi

      #echo -e '\e[5 q'
    '';
  };
}
