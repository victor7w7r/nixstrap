{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = '''';
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "erasedups" ];
    historyFileSize = 1000000;
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
    historySize = 10000;
    initExtra = '''';
    logoutExtra = '''';
    profileExtra = '''';
    sessionVariables = '''';
    shellAliases = '''';
    shellOptions = '''';
  };

   xdg.configFile.".blerc".text = '''';
}
