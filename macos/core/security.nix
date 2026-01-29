{ user, ... }:
{
  security.sudo = {
    enable = true;
    extraConfigFiles = {
      common = {
        enable = true;
        target = "~darwin-common";
        text = ''
          ${user} ALL = NOPASSWD: /bin/rm -rf /Library/Developer/CommandLineTools
          ${user} ALL = NOPASSWD: /usr/bin/xcode-select --install
          ${user} ALL = NOPASSWD: /usr/bin/xcodebuild -license accept
          ${user} ALL = NOPASSWD: /usr/sbin/DevToolsSecurity -enable
        '';
      };
      homebrew = {
        enable = true;
        target = "~darwin-homebrew";
        text = ''
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
        '';
      };
      mas = {
        enable = true;
        target = "~darwin-mas";
        text = ''
          ${user} ALL = PASSWD: /usr/local/bin/mas uninstall *
        '';
      };
    };
  };
}
