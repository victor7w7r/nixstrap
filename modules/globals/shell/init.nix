{
  den.default.provides.to-users.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs =
        let
          tmux-init = ''
            [[ $- != *i* ]] && return
            if [[ -z "$TMUX" \
                && -z "$SSH_TTY" \
                && "$TERM_PROGRAM" != "zed" \
                && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
                exec tmux new-session -A -s default
            fi
          '';
          kitty = ''
            if [[ -n "$KITTY_PID" ]]; then
              alias ssh="kitty +kitten ssh $@"
              alias ssh-compat="TERM=xterm-256color \ssh"
            fi
          '';
          paths = ''
            node_modules/.bin
            "$HOME/.bin"
            "$HOME/.local/bin"
            "$HOME/.cargo/bin"
            "$HOME/.emacs.d/bin"
          '';
          exports = ''
            if [[ "$TERM_PROGRAM" == "zed" ]]; then
              export EDITOR="zed"
              export VISUAL="zed --wait"
            fi

            if [[ "$TERMINAL" == "kitty" ]]; then
              export TERM="xterm-kitty"
            fi
          '';
          greetings = ''
            commandexist() {
              command -v "$1" &>/dev/null
            }

            if [[ "$OSTYPE" == "darwin"* ]]; then
              if commandexist clolcat; then
                uname -v | clolcat -F 0.2 -S "$(( RANDOM % 21 ))"
              else
                uname -v | clolcat -F 0.2 -S "$(( RANDOM % 21 ))"
              fi
            else
              if commandexist clolcat; then
                uname -m -n -o -v | clolcat -F 0.2 -S "$(( RANDOM % 21 ))"
              elif commandexist meow; then
                uname -m -n -o -v | meow
              else
                uname -m -n -o -v
              fi
            fi

            if commandexist clolcat; then
              echo "Welcome to $(uname)!" | clolcat -F 0.3 -S "$(( RANDOM % 21 ))"
            elif commandexist meow; then
              echo "Welcome to $(uname)!" | meow
            else
              echo "Welcome to $(uname)!"
            fi

            if commandexist cowsay && commandexist clolcat; then
              random-quote | cowthink "$(random-opts)" --random | clolcat -F 0.2 -S "$(( RANDOM % 21 ))"
            elif commandexist cowsay && commandexist meow; then
              random-quote | cowsay "$(random-opts)" --random | meow
            elif commandexist cowsay; then
              random-quote | cowsay "$(random-opts)" --random
            fi
          '';
        in
        {
          zsh.initContent = lib.mkMerge [
            (lib.mkOrder 450 tmux-init)
            (lib.mkOrder 500 kitty)
            (lib.mkOrder 550 ''
              unsetopt BEEP
              unsetopt HIST_BEEP
              unsetopt LIST_BEEP
              unset SSH_ASKPASS
              unset PROMPT_FIRST_TIME
              setopt shwordsplit
              
              bindkey '^[[1;2B' down-line-or-history
              bindkey '^[[1;2A' up-line-or-history
              bindkey '^[[1;2C' forward-word
              bindkey '^[[1;2D' backward-word
            '')
            (lib.mkOrder 600 ''
              path=(
                ${paths}
                $path
              )
              ${exports}
              #jump -- 'eval "$(jump shell)"'
              source <(cod init $$ zsh)
            '')
            (lib.mkOrder 1500 greetings)
            #(lib.mkOrder 1600 "echo -e '\e[5 q'")
          ];

          bash.bashrcExtra = lib.mkMerge [
            (lib.mkOrder 450 tmux-init)
            (lib.mkOrder 500 kitty)
            (lib.mkOrder 600 ''
              paths=(
                ${paths}
              )
              for p in "''${paths[@]}"; do if [ -d "$p" ]; then PATH="$p:$PATH"; fi; done
              export PATH
              ${exports}

              #source "${config.home.homeDirectory}/.config/bash/bash_it/bash_it.sh"
              #bash-it profile load victor7w7r

              if [[ -f "${pkgs.blesh}/share/blesh/ble.sh" ]]; then
                source "${pkgs.blesh}/share/blesh/ble.sh"
              fi
            '')
            (lib.mkOrder 1000 greetings)
            (lib.mkOrder 1100 ''
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
            '')
          ];
        };
    };

  /*
    #set -l toon (random choice {default,bud-frogs,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader})
    #fortune -s | cowsay -f $toon | clolcat
    #[[ ''${BLE_VERSION-} ]] && ble-attach
  */

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
