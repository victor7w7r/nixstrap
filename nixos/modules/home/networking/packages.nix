{
  host,
  system,
  pkgs,
  ...
}:
{
  home.packages = (
    with pkgs;
    (if system != "aarch64-linux" then [ mailspring ] else [ ])
    ++ (
      if host != "v7w7r-opizero2w" then
        [
          axel
          #ayugram-desktop
          lan-mouse
          legcord
          media-downloader
          mtr-gui
          music-discord-rpc
          (pkgs.callPackage ./custom/jdownloader.nix { })
        ]
      else
        [ ]
    )
  );
}
