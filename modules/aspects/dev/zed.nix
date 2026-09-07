{
  den.aspects.dev.zed =
    { user, ... }:
    {
      nixos.environment.persistence."/nix/persist".users."${user.name}".directories = [
        ".local/share/zed"
        ".vscode"
      ];

      provides.to-users.homeManager =
        { lib, pkgs, ... }:
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
          };

          xdg.configFile."zed/settings.json".text = builtins.toJSON {
            auto_install_extensions = {
              alpinejs-snippets = true;
              astro = true;
              bookmark = true;
              cargo-tom = true;
              color-highlight = true;
              comment = true;
              css-variables = true;
              dart = true;
              docker-compose = true;
              dockerfile = true;
              ellsp = true;
              emmet = true;
              env = true;
              git-firefly = true;
              github-actions = true;
              github-actions-snippets = true;
              html = true;
              html-snippets = true;
              import-cost-lsp = true;
              kotlin = true;
              log = true;
              lua = true;
              markdown-snippets = true;
              markdownlint = true;
              material-icon-theme = true;
              mcp-server-github = true;
              nix = true;
              npm-package-json-checker = true;
              oxc = true;
              package-json-upgrade-lsp = true;
              path-server-lsp = true;
              postgres-language-server = true;
              powershell = true;
              pylsp = true;
              react-typescript-snippets = true;
              rlsp-yaml = true;
              rust-snippets = true;
              sql = true;
              stylelint = true;
              svelte = true;
              todo-highlight-language-server = true;
              tokyo-night = true;
              tombi = true;
              toml = true;
              tsgo = true;
              typescript-snippets = true;
              unocss = true;
              vue = true;
              wc-language-server = true;
              xml = true;
            };

            auto_signature_help = true;
            auto_update = false;
            autosave = "on_focus_change";
            base_keymap = "VSCode";
            buffer_font_family = "JetBrainsMonoNL Nerd Font Mono";
            buffer_font_size = 12;
            buffer_line_height = "standard";
            code_lens = "on";
            collaboration_panel.button = false;
            colorize_brackets = true;
            cursor_blink = true;
            git_panel.dock = "left";
            file_types = {
              "GitHub Actions" = [
                ".github/workflows/*.yml"
                ".github/workflows/*.yaml"
              ];
            };
            hard_tabs = true;
            icon_theme = "Material Icon Theme";
            indent_guides = {
              coloring = "indent_aware";
              background_coloring = "indent_aware";
            };
            inlay_hints.enabled = false;
            jsx_tag_auto_close.enabled = true;
            linked_edits = true;
            line_ending = "enforce_lf";
            lsp_document_colors = "background";
            load_direnv = "shell_hook";
            global_lsp_settings.semantic_token_rules = [ { "token_type" = "comment"; } ];
            minimap.show = "auto";
            outline_panel.button = false;
            reduce_motion = "on";
            remove_trailing_whitespace_on_save = true;
            search.button = false;
            semantic_tokens.combined = true;
            selection_highlight = true;
            show_edit_predictions = true;
            show_whitespaces = "all";
            sticky_scroll.enabled = false;
            tab_size = 2;
            title_bar = {
              show_worktree_name = false;
              show_sign_in = false;
            };
            ui_font_family = "Ubuntu Nerd Font";
            ui_font_size = 16;
            use_autoclose = true;
            vertical_scroll_margin = 15;
            vim_mode = false;
            window_decorations = "server";

            agent = {
              button = false;
              dock = "right";
              sidebar_side = "right";
              favorite_models = [ ];
              model_parameters = [ ];
            };

            agent_servers = {
              auggie.type = "registry";
            };

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
            };

            edit_predictions = {
              mode = "eager";
              provider = "copilot";
            };

            project_panel = {
              auto_fold_dirs = true;
              auto_reveal_entries = false;
              entry_spacing = "standard";
              dock = "left";
              scrollbar.show = "auto";
            };

            telemetry = {
              diagnostics = false;
              metrics = false;
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
              env = {
                TERM = "kitty";
              };
              font_family = "JetBrainsMonoNL Nerd Font Mono";
              line_height = "comfortable";
              shell = "system";
            };
            language_servers = [
              "!eslint"
              "!vtsls"
              "!typescript-language-server"
              "..."
            ];
            lsp = {
              css-variables.settings.cssVariables = {
                lookupFiles = [
                  "**/*.css"
                  "**/*.scss"
                  "**/*.vue"
                  "**/*.svelte"
                ];
                blacklistFolders = [
                  "**/dist/**"
                  "**/node_modules/**"
                ];
                undefinedVarFallback = "info";
              };
              dart.binary = {
                path = "~/fvm/bin/fvm";
                arguments = [
                  "dart"
                  "language-server"
                  "--protocol=lsp"
                ];
              };
              nixd = {
                binary.ignore_system_version = false;
                initialization_options.formatting.command = [
                  "nixfmt"
                  "--quiet"
                  "--"
                ];
              };
              path-server-ls.settings = {
                basePath = [
                  "\${workspaceFolder}"
                  "\${document}"
                ];
                completion.triggerNextCompletion = true;
                highlight = {
                  enable = true;
                  highlightDirectory = true;
                };
              };
              oxlint.initialization_options.settings = {
                configPath = null;
                run = "onType";
                disableNestedConfig = false;
                fixKind = "safe_fix";
                unusedDisableDirectives = "deny";
              };
              oxfmt.initialization_options.settings = {
                "fmt.configPath" = null;
                run = "onSave";
              };
            };

            languages =
              {
                Dart = {
                  format_on_save = "on";
                  code_actions_on_format = {
                    source.organizeImports = true;
                    source.fixAll = true;
                  };
                };
                XML.format_on_save = "on";
                Nix = {
                  format_on_save = "on";
                  language_servers = [
                    "nixd"
                    "!nil"
                  ];
                };
              }
              // (lib.genAttrs
                [
                  "Astro"
                  "CSS"
                  "HTML"
                  "JavaScript"
                  "JSON"
                  "Markdown"
                  "MDX"
                  "SCSS"
                  "Svelte"
                  "TSX"
                  "Vue.js"
                  "YAML"
                ]
                (_: {
                  format_on_save = "on";
                  prettier.allowed = false;
                  formatter = [ { language_server.name = "oxfmt"; } ];
                })
              )
              // [
                "!vtsls"
                "!typescript-language-server"
                "tsgo"
                "..."
              ]
              |> (options: {
                CSS.language_servers = [
                  "vscode-css-language-server"
                  "emmet-language-server"
                ];
                HTML.language_servers = [
                  "vscode-css-language-server"
                  "emmet-language-server"
                  "unocss-language-server"
                ];
                TypeScript.language_servers = options;
                TSX.language_servers = options;
                JavaScript = options;
                Astro = [
                  "astro-language-server"
                  "unocss-language-server"
                ]
                ++ options;
                JSON.inlay_hints.enabled = true;
              });
          };
        };
    };
}
