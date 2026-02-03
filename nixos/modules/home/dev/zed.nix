{ ... }:
{
  programs.zed-editor = {
    enable = true;
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

      inlay_hints.enabled = true;
      indent_guides.coloring = "indent_aware";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      /*
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        "context_servers": {
          "mcp-server-github": {
            "enabled": true,
            "settings": {
              "github_personal_access_token": ""
            }
          }
        },
        "agent": {
          "default_model": {
            "provider": "copilot_chat",
            "model": "gpt-5-mini"
          },
          "model_parameters": []
        },
        "agent_servers": {
          "Auggie CLI": {
            "type": "custom",
            "command": "auggie",
            "args": ["--acp"],
            "env": {}
          }
        }
      */

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
        shell = "zsh";
        toolbar.title = true;
      };

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };

        nixd = {
          binary = {
            path = "/home/victor7w7r/.nix-profile/bin/nixd";
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
      title_bar = {
        show_menus = true;
        show_branch_name = true;
      };
    };
  };
}
