#!/usr/bin/env bash

getChanges() {
  declare -i added=0
  declare -i modified=0
  declare -i updated=0
  declare -i deleted=0

  for i in $(git -C "$path" --no-optional-locks status -s); do
    case $i in
    'A') added+=1 ;;
    'M') modified+=1 ;;
    'U') updated+=1 ;;
    'D') deleted+=1 ;;
    esac
  done

  output=""
  [ $added -gt 0 ] && output+="${added}A"
  [ $modified -gt 0 ] && output+=" ${modified}M"
  [ $updated -gt 0 ] && output+=" ${updated}U"
  [ $deleted -gt 0 ] && output+=" ${deleted}D"
  echo "$output"
}

getPaneDir() {
  nextone="false"
  for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}"); do
    if [ "$nextone" == "true" ]; then
      echo "$i"
      return
    fi
    if [ "$i" == "1" ]; then nextone="true"; fi
  done
}

checkForChanges() {
  no_untracked="" || no_untracked="-uno"
  if [ "$(checkForGitDir)" == "true" ]; then
    if [ "$(git -C "$path" --no-optional-locks status -s $no_untracked)" != "" ]; then
      echo "true"
    else
      echo "false"
    fi
  else
    echo "false"
  fi
}

checkForGitDir() {
  if [ "$(git -C "$path" rev-parse --abbrev-ref HEAD)" != "" ]; then echo "true"; else echo "false"; fi
}

getBranch() {
  if [ "$(checkForGitDir)" == "true" ]; then
    git -C "$path" rev-parse --abbrev-ref HEAD
  else
    echo "NO REPO"
  fi
}

getMessage() {
  if [ "$(checkForGitDir)" == "true" ]; then
    branch="$(getBranch)"
    output=""
    if [ "$(checkForChanges)" == "true" ]; then
      changes="$(getChanges)"
      output="! ${changes} $branch"
    else
      output="$✓ $branch"
    fi
    echo "$output"
  else
    echo ""
  fi
}

path=$(getPaneDir) && getMessage
