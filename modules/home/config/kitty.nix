{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      close_on_child_death = true;
      cursor_blink_interval = 400;
    };
  }
}
