{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "erasedups" ];
    historyFileSize = 1000000;
    historySize = 10000;
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
  };
}
