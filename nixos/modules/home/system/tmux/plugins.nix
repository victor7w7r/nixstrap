{ pkgs, ... }:
{
  programs.tmux.plugins = with pkgs; [
    tmuxPlugins.continuum
    tmuxPlugins.fingers
    tmuxPlugins.jump
    tmuxPlugins.logging
    tmuxPlugins.pain-control
    tmuxPlugins.resurrect
    tmuxPlugins.sidebar
    tmuxPlugins.tmux-fzf
    {
      plugin = tmuxPlugins.fzf-tmux-url;
      extraConfig = ''
        set -g @fzf-url-bind 'u'
        TMUX_FZF_LAUNCH_KEY="C-k"
        set -g @fzf-url-history-limit '2000'
      '';
    }
    {
      plugin = tmuxPlugins.better-mouse-mode;
      extraConfig = ''
        set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
        set -g @scroll-down-exit-copy-mode "off"
      '';
    }
    {
      plugin = tmuxPlugins.tmux-floax;
      extraConfig = ''
        set -g @floax-bind 'L'
        set -g @floax-border-color 'purple'
        set -g @floax-text-color '#e6e3d5'
      '';
    }
    {
      plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-suspend";
        version = "097f09dabd64084ab0c72ae75df4b5a89bb431a6";
        rtpFilePath = "suspend.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "MunifTanjim";
          repo = "tmux-suspend";
          rev = "1a2f806666e0bfed37535372279fa00d27d50d14";
          sha256 = "sha256-+1fKkwDmr5iqro0XeL8gkjOGGB/YHBD25NG+w3iW+0g=";
        };
      };
      extraConfig = "set -g @suspend_key 'F5'";
    }
    {
      plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-menus";
        version = "unstable-2023-10-20";
        rtpFilePath = "menus.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "jaclu";
          repo = "tmux-menus";
          rev = "764ac9cd6bbad199e042419b8074eda18e9d8b2d";
          sha256 = "sha256-tPUUaMASG/DtqxyN2VwCKPivYZkwVKjIScI99k6CJv8=";
        };
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
      plugin = tmuxPlugins.tmux-sessionx;
      extraConfig = ''
        set -g @fzf-url-bind 'u'
        TMUX_FZF_LAUNCH_KEY="C-k"
        set -g @fzf-url-history-limit '2000'
      '';
    }
    (tmuxPlugins.mkTmuxPlugin {
      pluginName = "named-snapshot";
      rtpFilePath = "named-snapshot.tmux";
      version = "872fede";
      src = fetchFromGitHub {
        owner = "spywhere";
        repo = "tmux-named-snapshot";
        rev = "872fedef62c1b732a56ca643f2354346912e06c3";
        hash = "sha256-EW1X+ZVl+hIIqAsj+bv6dkjQtNiBEhUYOQK/8bFEpV8=";
      };
    })
    (tmuxPlugins.mkTmuxPlugin {
      pluginName = "cowboy";
      version = "75702b6d";
      src = pkgs.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tmux-cowboy";
        rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
        sha256 = "sha256-KJNsdDLqT2Uzc25U4GLSB2O1SA/PThmDj9Aej5XjmJs=";
      };
    })
    (tmuxPlugins.mkTmuxPlugin rec {
      pluginName = "tmux-notify";
      version = "1.6.0";
      src = pkgs.fetchFromGitHub {
        owner = "rickstaa";
        repo = "tmux-notify";
        rev = "v${version}";
        hash = "sha256-J7RNQEfeEtWFe9AJ4dHN2d/sZvs0EtPwPG7f5DZg+tA=";
      };
      rtpFilePath = "tnotify.tmux";
      postInstall = ''
        find $target -type f -exec sed -i 's|notify-send |${libnotify}/bin/notify-send |g' {} +
      '';
    })
    (pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-power-zoom";
      version = "1.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "jaclu";
        repo = "tmux-power-zoom";
        rev = "6d618af224229ae653ffcc6d12c2146d536af79b";
        sha256 = "sha256-zFmEs6A5LJM6zI/aJ6j3Pf1yrNfF2G4ehRJJRz+qEwg=";
      };
      rtpFilePath = "power-zoom.tmux";
    })
    #browser
    #fingers
    #https://github.com/remi/teamocil
  ];
}
