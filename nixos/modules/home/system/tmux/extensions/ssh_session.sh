#!/usr/bin/env bash

show_ssh_session_port=$1

parse_ssh_port() {
  local port=$(echo "$1" | grep -Eo '\-p\s*([0-9]+)' | sed 's/-p\s*//')
  if [ -z "$port" ]; then local port=22; fi
  echo "$port"
}

parse_ssh_config() {
  for ssh_config in $(awk '
    $1 == "Host" {
      gsub("\\\\.", "\\\\.", $2);
      gsub("\\\\*", ".*", $2);
      host = $2;
      next;
    }
    $1 == "User" {
      $1 = "";
      sub( /^[[:space:]]*/, "" );
      printf "%s|%s\n", host, $0;
    }' $1); do
    local host_regex=${ssh_config%|*}
    local host_user=${ssh_config#*|}
    if [ "$2" == "$host_regex" ]; then
      ssh_user_found=$host_user
      break
    fi
  done

  echo "$ssh_user_found"
}

get_ssh_user() {
  if [ -f ~/.ssh/config ]; then ssh_user=$(parse_ssh_config ~/.ssh/config "$1"); fi
  if [ -z "$ssh_user" ]; then ssh_user=$(parse_ssh_config /etc/ssh/ssh_config "$1"); fi
  if [ -z "$ssh_user" ]; then ssh_user=$(whoami); fi
  echo "$ssh_user"
}

get_remote_info() {
  local command=$1
  local cmd=$({
    pgrep -flaP $(tmux display-message -p "#{pane_pid}")
    ps -o command -p $(tmux display-message -p "#{pane_pid}")
  } | xargs -I{} echo {} | grep ssh | sed -E 's/^[0-9]*[[:blank:]]*ssh //')
  local port=$(parse_ssh_port "$cmd")
  local cmd=$(echo "$cmd" | sed 's/\-p\s*'"$port"'//g')
  local user=$(echo "$cmd" | awk '{print $NF}' | cut -f1 -d@)
  local host=$(echo "$cmd" | awk '{print $NF}' | cut -f2 -d@)

  if [ $user == $host ]; then local user=$(get_ssh_user "$host"); fi

  case "$1" in
  "whoami") echo $user ;;
  "hostname") echo $host ;;
  "port") echo $port ;;
  *) echo "$user@$host:$port" ;;
  esac
}

get_info() {
  if $(ssh_connected); then echo $(get_remote_info $1); else echo $($1); fi
}

ssh_connected() {
  local cmd=$(tmux display-message -p "#{pane_current_command}")
  [ $cmd = "ssh" ] || [ $cmd = "sshpass" ]
}

main() {
  hostname=$(get_info hostname)
  user=$(get_info whoami)
  if ! $(ssh_connected); then
    echo ""
  elif $(ssh_connected) && [ "$show_ssh_session_port" == "true" ]; then
    port=$(get_info port)
    echo $user@$hostname:$port
  else
    echo $user@$hostname
  fi

}

main
