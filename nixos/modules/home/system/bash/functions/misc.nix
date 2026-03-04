''
  equals() {
    realpath "$(which "$1")"
  }

  bak() {
    if [ $# -ne 1 ]; then
      echo "1 path must be supplied"
      return 1
    fi
    file=$(basename "$1" '.bak')
    other="$file.bak"
    if [ -e "$1" ]; then
      if [ -e "$other" ]; then
        mv "$1" "$other.tmp"
        mv "$other" "$1"
        mv "$other.tmp" "$other"
      else
        mv "$1" "$other"
      fi
    else
      if [ -e "$other" ]; then
        mv "$other" "$1"
      else
        echo "Neither $1 nor $other exist"
        return 1
      fi
    fi
  }

  ex() {
    if [ -f "$1" ]; then
      filename=$(basename "$1")
      foldername=$(echo "$filename" | sed 's/\.[^.]*$//')
      mkdir -p "$foldername"
      case "$1" in
      *.tar.bz2)
        tar xjf "$1" -C "$foldername"
        ;;
      *.tar.gz)
        tar xzf "$1" -C "$foldername"
        ;;
      *.bz2)
        bunzip2 -k "$1"
        mv "$(basename "$1" .bz2)" "./$foldername/"
        ;;
      *.rar)
        unrar x "$1" "./$foldername/"
        ;;
      *.gz)
        gunzip -k "$1"
        mv "$(basename "$1" .gz)" "./$foldername/"
        ;;
      *.tar)
        tar xf "$1" -C "./$foldername/"
        ;;
      *.tbz2)
        tar xjf "$1" -C "./$foldername/"
        ;;
      *.tgz)
        tar xzf "$1" -C "./$foldername/"
        ;;
      *.zip)
        unzip -d "./$foldername/" "$filename"
        ;;
      *.Z)
        uncompress "$filename"
        mv "$(basename "$filename" ".Z")" "./$foldername/"
        ;;
      *.7z)
        7z x "$filename" "-o./$foldername/"
        ;;
      *)
        echo "'$filename' cannot be extracted via ex()"
        ;;
      esac
    else
      echo "'$filename' is not a valid file"
    fi
  }

  mkcd() {
    mkdir -p "$1" && cd "$1" || exit
  }

  mvcd() {
    if [ $# -gt 1 ]; then
      mkdir -p "$2"
      mv "$1" "$2"
      cd "$2" || exit
    fi
  }

  cheat() {
    navi_command='navi --print --fzf-overrides "--no-multi --no-height --no-sort"'
    if [ $# -eq 0 ]; then
      eval "$navi_command"
    else
      eval "$navi_command" --query "$@"
    fi
  }

  cwd() {
    if [ "$OS" = "Linux" ]; then
      echo -n "$(echo $PWD | sed "s|^$HOME|~|")" | tr -d "\r\n" | xclip -selection clipboard -i
    elif [ "$OS" = "Darwin" ]; then
      echo -n "$(echo $PWD | sed "s|^$HOME|~|")" | tr -d "\r\n" | pbcopy
    fi
    if [ -n "$TMUX" ]; then
      echo -n "$(echo $PWD | sed "s|^$HOME|~|")" | tr -d "\r\n" | tmux load-buffer -
    fi
  }

  dus() {
    command dust -r -d 1 "$@"
  }

  fkill() {
    local pids
    if [ "$OS" = "Linux" ]; then
      pids=$(ps -f -u "$USER" | sed 1d | fzf | awk '{print $2}')
    elif [ "$OS" = "Darwin" ]; then
      pids=$(ps -f -u "$USER" | sed 1d | fzf | awk '{print $3}')
    else
      echo 'Error: unknown platform.'
      return
    fi
    echo "$pids"
    if [ -n "$pids" ]; then
      echo "$pids" | xargs kill -9 "$@"
    fi
  }

  mux() {
    if [ $# -eq 1 ] && [ "$1" = "stop" ]; then
      tmuxinator stop "$(tmux display-message -p '#S')"
    else
      tmuxinator "$@"
    fi
  }

  tka() {
    tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}
  }

  tna() {
    tmux new-session -As "$(basename "$PWD" | tr . -)"
  }

  bin() {
    ln -sr "$(realpath "$1")" /usr/local/bin/
  }

  s() {
    sudo "$@"
  }

  f() {
    find . -name "*$1*" 2>/dev/null
  }

  path_add() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
      export PATH="$PATH:$1"
    fi
    echo "Updated PATH: $PATH"
  }

  compress() {
    if [[ -n "$1" ]]; then
      local file=$1
      shift
      case "$file" in
      *.tar) tar cf "$file" "$*" ;;
      *.tar.bz2) tar cjf "$file" "$*" ;;
      *.tar.gz) tar czf "$file" "$*" ;;
      *.tgz) tar czf "$file" "$*" ;;
      *.zip) zip "$file" "$*" ;;
      *.rar) rar "$file" "$*" ;;
      *) tar zcvf "$file.tar.gz" "$*" ;;
      esac
    else
      echo 'usage: compress <foo.tar.gz> ./foo ./bar'
    fi
  }
''
