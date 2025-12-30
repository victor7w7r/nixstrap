{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    git-extras
    emacs-nox

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
}
