{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      command_timeout = 500;

      format = ''
        [╭╴](#7088ff)$os$username[@](#7088ff)$hostname\
        $jobs$directory$sudo$cmd_duration$fill\
        $shell$status$localip$time
        [╰╴](#7088ff)$character$custom
      '';

      character = {
        success_symbol = ''[\$](bold #cc8afc)'';
        error_symbol = ''[\$](bold #cc8afc)'';
        vimcmd_symbol = ''[](bold turquoise)'';
      };

      os = {
        disabled = false;
        format = ''[$symbol]($style)'';
        style = "bold #7088ff";
        symbols = {
          Windows = " ";
          Arch = "󰣇";
          Android = " ";
          Debian = " ";
          FreeBSD = " ";
          NetBSD = "󰉀 ";
          OpenBSD = " ";
          Macos = "󰀵";
          Unknown = "󰠥";
        };
      };

      username = {
        disabled = false;
        format = ''(black bold)[$user]($style)'';
        show_always = true;
        style_user = "bold #2BB7FB";
        style_root = "bold #ff5990";
      };

      hostname = {
        disabled = false;
        format = ''[$hostname ]($style)'';
        ssh_only = false;
        style = "bold #2BB7FB";
      };

      jobs = {
        format = ''[$symbol$number]($style) '';
        style = "bold #83e6ff";
        symbol = "[▶](#83e6ff)";
      };

      directory = {
        format = ''[$path]($style)[$read_only ]($read_only_style)'';
        home_symbol = "~";
        read_only = "  ";
        style = "italic #83e6ff";
        truncation_length = 3;
        truncation_symbol = "…/";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      sudo = {
        disabled = false;
        format = ''[\[$symbol\] ]($style)'';
        style = "bold #ff5990";
        symbol = "⚡";
      };

      cmd_duration = {
        disabled = false;
        format = ''[ $duration]($style) '';
        style = "dimmed #cc8afc";
      };

      fill.symbol = " ";

      status = {
        disabled = false;
        failure_style = "bold #ff5990";
        format = ''[$symbol\[$status\] ]($style)'';
        symbol = ''\\(╯°□°）╯'';
      };

      localip = {
        disabled = false;
        format = ''[$localipv4]($style)[ 󰋑  ](#cc8afc)'';
        style = "italic dimmed #7088ff";
        ssh_only = false;
      };

      time = {
        disabled = false;
        format = ''[$time]($style)'';
        style = "italic #83e6ff";
        time_format = ''%I:%M:%S'';
        use_12hr = true;
        utc_time_offset = "local";
      };
    };
  };
}
