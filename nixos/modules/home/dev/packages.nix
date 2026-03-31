{
  pkgs,
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
    ++ (
      if (host == "v7w7r-macmini81") then
        [
          jetbrains.datagrip
        ]
      else
        [ ]
    )
  );
}
