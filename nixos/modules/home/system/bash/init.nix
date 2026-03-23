{ pkgs, ... }:
{
  programs.bash.bashrcExtra = ''
    [[ $- != *i* ]] && return
    [[ -z "$TMUX" \
      && -z "$SSH_TTY" \
      && "$TERM_PROGRAM" != "zed" \
      && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" \
    ]] && exec tmux new-session -A -s default

    paths=(
      node_modules/.bin
      "$HOME/.bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.venv/bin"
    )

    for p in "''${paths[@]}"; do if [ -d "$p" ]; then PATH="$p:$PATH"; fi; done
    export PATH

    #[[ -f "$BASHDOTDIR/.private" ]] && source "$BASHDOTDIR/.private"

    ${(import ./functions/bofh.nix)}
    ${(import ./functions/kaomoji.nix)}
    ${(import ./functions/misc.nix)}
    ${(import ./functions/node.nix)}
    ${(import ./functions/quotes.nix)}
    ${(import ./functions/utils.nix)}

    source "$BASH_IT/bash_it.sh"
    bash-it profile load victor7w7r

    if [[ -f "${pkgs.blesh}/share/blesh/ble.sh" ]]; then
      source "${pkgs.blesh}/share/blesh/ble.sh"
    fi

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
      random-quote | cowsay "$(random-opts)" --random | clolcat
    elif commandexist cowsay && commandexist meow; then
      random-quote | cowsay "$(random-opts)" --random | meow
    elif commandexist cowsay; then
      random-quote | cowsay "$(random-opts)" --random
    fi

    post() {
      local last_exit=$1

      if [[ $- == *i* ]] && \
        [[ -z "$TMUX" ]] && \
        command -v tmux >/dev/null 2>&1 && \
        [[ "$TERM_PROGRAM" != "zed" ]] && \
        [[ -z "$SSH_TTY" ]]; then
        tmux set-environment -g LAST_EXIT "$last_exit"
        tmux set-environment -g LAST_CMD_TS "$(date +%s%N)"
      fi
    }

    PROMPT_COMMAND='post $?'
  '';

  /*
    #set -l toon (random choice {default,bud-frogs,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader})
    #fortune -s | cowsay -f $toon | clolcat
    #[[ ''${BLE_VERSION-} ]] && ble-attach
  */

}
