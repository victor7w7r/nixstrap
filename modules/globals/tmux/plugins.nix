{ inputs, ... }:
{
  flake-file.inputs = {
    tmux-suspend = {
      url = "github:MunifTanjim/tmux-suspend/1a2f806666e0bfed37535372279fa00d27d50d14";
      flake = false;
    };

    tmux-menus = {
      url = "github:jaclu/tmux-menus/764ac9cd6bbad199e042419b8074eda18e9d8b2d";
      flake = false;
    };

    tmux-named-snapshot = {
      url = "github:spywhere/tmux-named-snapshot/872fedef62c1b732a56ca643f2354346912e06c3";
      flake = false;
    };

    tmux-cowboy = {
      url = "github:tmux-plugins/tmux-cowboy/75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      flake = false;
    };

    tmux-notify = {
      url = "github:rickstaa/tmux-notify/75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      flake = false;
    };

    tmux-power-zoom = {
      url = "github:jaclu/tmux-power-zoom/6d618af224229ae653ffcc6d12c2146d536af79b";
      flake = false;
    };
  };

  den.default.provides.to-users.homeManager =
    { pkgs, ... }:
    {
      programs.tmux.plugins = with pkgs.tmuxPlugins; [
        continuum
        fingers
        jump
        logging
        pain-control
        resurrect
        sidebar
        tmux-fzf
        {
          plugin = fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-bind 'u'
            TMUX_FZF_LAUNCH_KEY="C-k"
            set -g @fzf-url-history-limit '2000'
          '';
        }
        {
          plugin = better-mouse-mode;
          extraConfig = ''
            set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
            set -g @scroll-down-exit-copy-mode "off"
          '';
        }
        {
          plugin = tmux-floax;
          extraConfig = ''
            set -g @floax-bind 'L'
            set -g @floax-border-color 'purple'
            set -g @floax-text-color '#e6e3d5'
          '';
        }
        {
          plugin = mkTmuxPlugin {
            pluginName = "tmux-suspend";
            version = "097f09dabd64084ab0c72ae75df4b5a89bb431a6";
            rtpFilePath = "suspend.tmux";
            src = inputs.tmux-suspend;
          };
          extraConfig = "set -g @suspend_key 'F5'";
        }
        {
          plugin = mkTmuxPlugin {
            pluginName = "tmux-menus";
            version = "unstable-2023-10-20";
            rtpFilePath = "menus.tmux";
            src = inputs.tmux-menus;
          };
          extraConfig = ''
            set -g @menus_simple_style_selected 'fg=#414559,bg=#e5c890'
            set -g @menus_simple_style 'bg=#414559'        # @thm_surface_0
            set -g @menus_simple_style_border 'bg=#414559' # @thm_surface_0
            set -g @menus_nav_next '#[fg=colour220]-->'
            set -g @menus_nav_prev '#[fg=colour71]<--'
            set -g @menus_nav_home '#[fg=colour84]<=='
          '';
        }
        {
          plugin = tmux-sessionx;
          extraConfig = ''
            set -g @fzf-url-bind 'u'
            TMUX_FZF_LAUNCH_KEY="C-k"
            set -g @fzf-url-history-limit '2000'
          '';
        }
        (mkTmuxPlugin {
          pluginName = "named-snapshot";
          rtpFilePath = "named-snapshot.tmux";
          version = "872fede";
          src = inputs.tmux-named-snapshot;
        })
        (mkTmuxPlugin {
          pluginName = "cowboy";
          version = "75702b6d";
          src = inputs.tmux-cowboy;
        })
        (mkTmuxPlugin {
          pluginName = "tmux-notify";
          version = "1.6.0";
          src = inputs.tmux-notify;
          rtpFilePath = "tnotify.tmux";
          postInstall = "find $target -type f -exec sed -i 's|notify-send |${pkgs.libnotify}/bin/notify-send |g' {} +";
        })
        (mkTmuxPlugin {
          pluginName = "tmux-power-zoom";
          version = "1.0.0";
          src = inputs.tmux-power-zoom;
          rtpFilePath = "power-zoom.tmux";
        })
        #browser
        #fingers
        #https://github.com/remi/teamocil
      ];
    };
}
