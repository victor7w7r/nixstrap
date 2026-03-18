{
  pkgs,
  lib,
  host,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      bruno
      neovim
      cool-retro-term
      git-credential-manager
      lazygit
      rustup
      windterm
    ]
    ++ (lib.optional (host == "v7w7r-macmini81") [
      jetbrains.datagrip
    ])
  );
}
