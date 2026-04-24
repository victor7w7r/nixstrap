{
  pkgs,
  host,
  system,
  inputs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      bruno
      #neovim
      cool-retro-term
      git-credential-manager
      (inputs.claude-desktop.packages.${system}.claude-desktop.override {
        nodePackages = { inherit (pkgs) asar; };
      })
      lazygit
    ]
    ++ (
      if (host == "v7w7r-macmini81") then
        [
          jetbrains.datagrip
        ]
      else
        [ ]
    )
    ++ (if system != "aarch64-linux" then [ windterm ] else [ ])
  );
}
