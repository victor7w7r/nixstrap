{ ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "basher"
      "dart"
      "git-firefly"
      "ini"
      "log"
      "lua"
      "material-icon-theme"
      "nix"
      "tokyo-night"
      "toml"
      "tmux"
    ];

    userSettings = {
      inlay_hints.enabled = true;
      indent_guides.coloring = "indent_aware";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      hour_format = "hour24";
      base_keymap = "VSCode";
      auto_update = false;
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 12;
      show_whitespaces = "all";

      theme = {
        mode = "system";
        light = "Tokyo Night";
        dark = "Tokyo Night";
      };

      terminal = {
        blinking = "on";
        copy_on_select = true;
        dock = "bottom";
        env.TERM = "kitty";
        font_family = "JetBrainsMono Nerd Font";
        line_height = "comfortable";
        shell = "szsh";
        toolbar.title = true;
      };

      icon_theme = "Material Icon Theme";
      title_bar = {
        show_menus = true;
        show_branch_name = true;
      };
    };
  };
}
