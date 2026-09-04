{
  den.aspects.dev.zed =
    { user, ... }:
    {
      nixos.environment.persistence."/nix/persist".users."${user.name}".directories = [
        ".config/zed"
        ".local/share/zed"
        ".vscode"
      ];

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          programs.vscode.enable = true;
          programs.zed-editor = {
            enable = true;
            extraPackages = with pkgs; [
              bash-language-server
              nixd
              nixfmt
            ];
            installRemoteServer = true;
            extensions = [
              "alpinejs-snippets"
              "astro"
              "basher"
              "biome"
              "bookmark"
              "comment"
              "color-highlight"
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
              "markdown-snippets"
              "markdownlint"
              "material-icon-theme"
              "mcp-server-github"
              "nix"
              "powershell"
              "pylsp"
              "react-typescript-snippets"
              "rlsp-yaml"
              "rust"
              "sql"
              "svelte"
              "stylelint"
              "todo-highlight-language-server"
              "tokyo-night"
              "vue"
              "toml"
              "tmux"
              "unocss"
              "xml"
              "wc-language-server"
            ];

            userSettings = {
              context_servers = {
                mcp-server-github = {
                  enabled = true;
                  remote = false;
                  settings.github_personal_access_token = null;
                };
              };

              diagnostics = {
                button = true;
                include_warnings = true;
                inline = {
                  enabled = true;
                  update_debounce_ms = 150;
                  padding = 4;
                  min_column = 0;
                  max_severity = null;
                };
                cargo = null;
              };

              edit_predictions = {
                mode = "eager";
                provider = "copilot";
              };

              project_panel = {
                auto_fold_dirs = true;
                auto_reveal_entries = false;
                dock = "left";
              };

              agent = {
                button = false;
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

              telemetry = {
                diagnostics = false;
                metrics = false;
              };

              whitespace_map = {
                space = "•";
                tab = " ";
              };

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

              lsp = {
                nixd = {
                  binary = {
                    "ignore_system_version" = false;
                    "path" = "${pkgs.nixd}/bin/nixd";
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
                  formatter.external = {
                    command = "nixfmt";
                    arguments = [
                      "--quiet"
                      "--"
                    ];
                  };
                  format_on_save = "on";
                  language_servers = [ "nixd" ];
                  tab_size = 2;
                };
              };

              agent_servers."auggie".type = "registry";
              auto_update = false;
              autosave = "on_focus_change";
              base_keymap = "VSCode";
              buffer_font_size = 12;
              collaboration_panel.button = false;
              colorize_brackets = true;
              cursor_blink = true;
              format_on_save = true;
              git_panel.dock = "left";
              hard_tabs = true;
              icon_theme = "Material Icon Theme";
              indent_guides.coloring = "indent_aware";
              inlay_hints.enabled = true;
              jsx_tag_auto_close.enabled = true;
              load_direnv = "shell_hook";
              minimap.show = "auto";
              outline_panel.button = false;
              search.button = false;
              show_edit_predictions = true;
              show_whitespaces = "trailing";
              sticky_scroll = false;
              tab_size = 2;
              title_bar.show_sign_in = false;
              ui_font_size = 16;
              vertical_scroll_margin = 15;
              vim_mode = false;
            };
          };
        };
    };
}
