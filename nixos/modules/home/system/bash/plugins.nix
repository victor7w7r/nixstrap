{ ... }:
{
  home.file.".config/bash/bash_it" = {
    source = builtins.fetchGit {
      url = "https://github.com/Bash-it/bash-it.git";
      rev = "4c5ac697f593169ab09a63e0f78f85a20d01c47a";
    };
    recursive = true;
  };

  xdg.configFile = {
    "bash/blerc".text = ''
      bleopt prompt_ps1_transient=always:trim
      bleopt exec_exit_mark=
      bleopt exec_errexit_mark=
      bleopt prompt_ps1_final='$(starship module character)'
    '';

    "bash/bashit-profile".text = ''
      plugins alias-completion
      plugins autojump
      plugins base
      plugins battery
      plugins browser
      plugins colors
      plugins direnv
      plugins dirs
      plugins docker-compose
      plugins docker
      plugins fzf
      plugins git
      plugins git-subrepo
      plugins history
      plugins history-search
      plugins history-substring-search
      plugins jump
      plugins man
      plugins pyenv
      plugins python
      plugins sshagent
      plugins ssh
      plugins sudo
      plugins thefuck
      plugins tmuxinator
      plugins tmux
      plugins todo
      plugins zoxide

      completion bash-it
      completion brew
      completion defaults
      completion dirs
      completion docker
      completion docker-compose
      completion export
      completion git
      completion rustup
      completion ssh
      completion system
      completion tmux

      aliases bash-it
      aliases clipboard
      aliases curl
      aliases directory
      aliases docker
      aliases docker-compose
      aliases editor
      aliases general
      aliases git
      aliases homebrew
      aliases homesick
      aliases systemd
      aliases tmux
      aliases vim
    '';
  };
}
