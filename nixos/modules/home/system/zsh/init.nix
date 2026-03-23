{ lib, ... }:
{
  imports = [ (import ./functions) ];
  programs.zsh.initContent = lib.mkMerge [
    (lib.mkOrder 450 ''
      [[ $- != *i* ]] && return
      [[ -z "$TMUX" \
        && -z "$SSH_TTY" \
        && "$TERM_PROGRAM" != "zed" \
        && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" \
      ]] && exec tmux new-session -A -s default
    '')
    (lib.mkOrder 550 ''
      unsetopt BEEP
      unsetopt HIST_BEEP
      unsetopt LIST_BEEP
      unset SSH_ASKPASS
      unset PROMPT_FIRST_TIME

      bindkey '^[[1;2B' down-line-or-history
      bindkey '^[[1;2A' up-line-or-history
      bindkey '^[[1;2C' forward-word
      bindkey '^[[1;2D' backward-word
    '')

    (lib.mkOrder 1000 ''
      path=(
        node_modules/.bin
        "$HOME/.bin"
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "$HOME/.emacs.d/bin"
        $path
      )

      if [[ "$TERM_PROGRAM" == "zed" ]]; then
        export EDITOR="zed"
        export VISUAL="zed --wait"
      fi

      if [[ "$TERMINAL" == "kitty" ]]; then
        export TERM="xterm-kitty"
      fi

      #jump -- 'eval "$(jump shell)"'
      source <(cod init $$ zsh)
    '')

    (lib.mkOrder 1500 ''
      commandexist() {
        command -v "$1" &>/dev/null
      }

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
         random-quote | cowsay $(random-opts) --random | clolcat
       elif commandexist cowsay && commandexist meow; then
         random-quote | cowsay $(random-opts) --random | meow
       elif commandexist cowsay; then
         random-quote | cowsay $(random-opts) --random
       fi

      echo -e '\e[5 q'
    '')
  ];
  /*
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
  */

}
