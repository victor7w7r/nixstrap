{
  den.aspects.dev.zed =
    { user, ... }:
    {
      nixos.environment.persistence."/nix/persist".users."${user.name}".directories = [
        ".config/zed"
        ".local/share/zed"
      ];
    };

  provides.to-users.homeManager =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = pkgs.zed-editor-fhs;
        extraPackages = with pkgs; [ nixd ];
        extensions = [
          "astro"
          "basher"
          "biome"
          "cargo-tom"
          "dart"
          "docker-compose"
          "dockerfile"
          "elisp"
          "emmet"
          "env"
          "git-firefly"
          "html"
          "ini"
          "java"
          "kotlin"
          "log"
          "lua"
          "make"
          "material-icon-theme"
          "mcp-server-github"
          "nix"
          "powershell"
          "pylsp"
          "react-typescript-snippets"
          "rust"
          "sql"
          "svelte"
          "tokyo-night"
          "vue"
          "tailwind-theme"
          "toml"
          "tmux"
          "unocss"
        ];

        userSettings = {
          assistant = {
            enabled = true;
            version = "2";
            default_open_ai_model = null;

            default_model = {
              provider = "zed.dev";
              model = "claude-3-5-sonnet-latest";
            };
          };

          context_servers = {
            mcp-server-github = {
              enabled = true;
              remote = false;
              settings.github_personal_access_token = null;
            };
          };

          edit_predictions = {
            mode = "eager";
            provider = "copilot";
          };

          agent_servers."auggie".type = "registry";

          whitespace_map = {
            space = "•";
            tab = " ";
          };

          load_direnv = "shell_hook";

          outline_panel.button = false;
          collaboration_panel.button = false;
          minimap.show = "auto";
          project_panel.dock = "left";
          git_panel.dock = "left";

          agent = {
            dock = "right";
            sidebar_side = "right";
            favorite_models = [ ];
            model_parameters = [ ];
            /*
              "default_model": {
                "provider": "copilot_chat",
                "model": "gpt-5-mini"
              },
            */
          };

          inlay_hints.enabled = true;
          indent_guides.coloring = "indent_aware";
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          base_keymap = "VSCode";
          auto_update = false;
          vim_mode = false;
          ui_font_size = 16;
          buffer_font_size = 12;
          show_whitespaces = "all";

          features.edit_prediction_provider = "copilot";
          autosave = "on_focus_change";
          cursor_blink = true;

          theme = {
            mode = "system";
            light = "Tokyo Night";
            dark = "Tokyo Night";
          };

          terminal = {
            blinking = "terminal_controlled";
            copy_on_select = true;
            dock = "bottom";
            env.TERM = "kitty";
            font_family = "JetBrainsMono Nerd Font";
            line_height = "comfortable";
            shell = "system";
          };

          title_bar.show_sign_in = false;

          lsp = {
            rust-analyzer = {
              binary = {
                path_lookup = true;
              };
            };

            nixd = {
              binary = {
                path = "/run/current-system/sw/bin/nixd";
              };
              initialization_options = {
                formatting = {
                  command = [ "nixfmt" ];
                };
              };
            };
          };

          languages = {
            Nix = {
              formatter = "language_server";
              format_on_save = "on";
              language_servers = [ "nixd" ];
              tab_size = 2;
            };
          };

          icon_theme = "Material Icon Theme";
        };
      };
    };
}
