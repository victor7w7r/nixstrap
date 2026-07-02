{ lib, ... }:
let
  commandexist = "command -v $1 &>/dev/null";
  random-opts = ''
    local options=(-b -d -g -p -s -t -w -y)
    echo ''${options[$RANDOM % ''${#options[@]} + 1]}
  '';
  is-macos = "[[ $OSTYPE = *darwin* ]] || return 1";
  is-linux = "[[ $OSTYPE = *linux* ]] || return 1";
  is-cygwin = ''[[ -n "$MSYSTEM" ]] || return 1'';
  is-notcygwin = ''[[ -z "$MSYSTEM" ]] || return 1'';
  setopt_if_exists = ''if [[ "''${options[$1]+1}" ]]; then setopt "$1"; fi'';
  x = ''
    if [ $# -eq 1 ]; then
      export $1
    elif [ $# -ge 2 ]; then
      export $1="''${@:2}"
    else
      echo "Usage: x VARIABLE [VALUE]"
      return 1
    fi
  '';
in
{
  den.default.provides.to-users.homeManager.programs = {
    zsh.siteFunctions = {
      inherit
        commandexist
        random-opts
        is-macos
        is-linux
        is-cygwin
        is-notcygwin
        setopt_if_exists
        x
        ;
    };
    bash.bashrcExtra = (
      lib.mkOrder 800 ''
        commandexist() {
          ${commandexist}
        }

        random-opts() {
          ${random-opts}
        }

        is-macos() {
          ${is-macos}
        }

        is-linux() {
          ${is-linux}
        }

        is-cygwin() {
          ${is-cygwin}
        }

        is-notcygwin() {
          ${is-notcygwin}
        }

        setopt_if_exists() {
          ${setopt_if_exists}
        }

        x() {
          ${x}
        }
      ''
    );
  };
}
