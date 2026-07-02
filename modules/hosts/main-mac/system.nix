{ inputs, ... }:
{
  den.aspects.main-mac.system.darwin =
    {
      host,
      pkgs,
      user,
      ...
    }:
    {
      environment = {
        variables.RLIMIT_NOFILE = "65536";
        pathsToLink = [ "/Applications" ];
        systemPath = [ "/usr/local/bin" ];
        etc = {
          home-manager.source = "${inputs.home-manager}";
          nixpkgs.source = "${pkgs.path}";
          stable.source = "${inputs.stable}";
          "sudoers.d/timeout".text = ''
            Defaults timestamp_timeout=30
          '';
          "gitconfig".text = ''
            [filter "lfs"]
              clean = git-lfs clean -- %f
              smudge = git-lfs smudge -- %f
              process = git-lfs filter-process
              required = true
          '';
        };
      };

      networking = {
        computerName = host;
        localHostName = host;
        hostName = host;
        applicationFirewall = {
          enable = true;
          blockAllIncoming = false;
          allowSigned = true;
          allowSignedApp = true;
          enableStealthMode = false;
        };
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts-color-emoji
      ];

      security.sudo.extraConfig = ''
        ${user} ALL = NOPASSWD: /bin/rm -rf /Library/Developer/CommandLineTools
        ${user} ALL = NOPASSWD: /usr/bin/xcode-select --install
        ${user} ALL = NOPASSWD: /usr/bin/xcodebuild -license accept
        ${user} ALL = NOPASSWD: /usr/sbin/DevToolsSecurity -enable

        ${user} ALL = PASSWD:SETENV: /bin/mkdir -p /Applications
        ${user} ALL = PASSWD:SETENV: /bin/mv /usr/local/Caskroom/*.app /Applications/*.app
        ${user} ALL = PASSWD:SETENV: /bin/mv /opt/homebrew/Caskroom/*.app /Applications/*.app

        ${user} ALL = PASSWD:SETENV: /usr/sbin/installer -pkg /opt/homebrew/Caskroom/*.pkg -target /
        ${user} ALL = PASSWD:SETENV: /usr/bin/env * /usr/sbin/installer -pkg /usr/local/Caskroom/*.pkg -target /
        ${user} ALL = PASSWD:SETENV: /usr/bin/env * /usr/sbin/installer -pkg /opt/homebrew/Caskroom/*.pkg -target /
        ${user} ALL = PASSWD:SETENV: /usr/sbin/pkgutil --forget *
        ${user} ALL = PASSWD:SETENV: /usr/local/Caskroom/*/*/uninstall.tool
        ${user} ALL = PASSWD:SETENV: /opt/homebrew/Caskroom/*/*/uninstall.tool

        ${user} ALL = PASSWD:SETENV: /usr/bin/xargs -0 -- /bin/rm --
        ${user} ALL = PASSWD:SETENV: /usr/bin/xargs -0 -- /usr/local/Homebrew/Library/Homebrew/cask/utils/rmdir.sh

        ${user} ALL = PASSWD: /usr/local/bin/mas uninstall *
      '';

    };
}
