{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      desed
      fw
      hub
      just
      zsh-forgit
      #https://github.com/GianlucaP106/mynav

      github-copilot-cli
      jan
      ollama-rocm
      #uv pip elia-chat gpterminator

      atac
      xh
      httpie
      curlie
      http-prompt
      posting
      glow
      jless
      dos2unix
      lemmeknow
      #https://github.com/jwt-rs/jwt-ui
      #https://crates.io/crates/loc
      #https://crates.io/crates/kyun
      #https://github.com/ariasmn/ugm
      #https://github.com/Owloops/updo

      dblab
      gobang
      rainfrog

      ktlint
      shellcheck

      tracexec
    ];

  programs = {
    #aichat.enable = true;
    #aider-chat.enable = true;
    direnv.enable = true;
    gitui.enable = true;
    difftastic.enable = true;
    lazygit.enable = true;
    lazysql.enable = true;
    mods.enable = true;
    meli.enable = true;
    visidata.enable = true;
  };
}
