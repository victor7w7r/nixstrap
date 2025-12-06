{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      github-copilot-cli
      hub
      just
      git-extras
      zsh-forgit
      ktlint
      shellcheck
      ollama-rocm
      jan

      #uv pip elia-chat gpterminator
      rainfrog
      gobang
      dblab
      tracexec

      atac
      xh
      #https://github.com/jwt-rs/jwt-ui
      httpie
      curlie
      http-prompt
      posting

      glow
      jless
      dos2unix
      lemmeknow
      #https://crates.io/crates/loc
      # https://crates.io/crates/kyun
      # https://github.com/ariasmn/ugm
    ]
  );

  programs.gitui.enable = true;
  programs.lazygit.enable = true;
  programs.direnv.enable = true;
  programs.difftastic.enable = true;
  programs.aichat.enable = true;
  programs.aider-chat.enable = true;
  programs.mods.enable = true;

  programs.meli.enable = true;
  programs.visidata.enable = true;

}
