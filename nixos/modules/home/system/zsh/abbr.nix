{ ... }:
{
  programs.zsh = {
    zsh-abbr.enable = true;
    abbreviations = {
      c = "clear";
      ":q" = "exit";
      ":wq" = "exit";

      "-" = "cd -";
      "~" = "cd ~";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      tree = "ll --tree --level=2";
      t2 = "ll --tree --level=2";
      t2a = "ll --tree --level=2 -a";

      mux = "tmuxinator";
      ms = "tmuxinator start";
      msa = "tmuxinator start mac-bootstrap";
      msb = "tmuxinator start bible_first_online";
      msc = "tmuxinator start bf_curriculum";
      msd = "tmuxinator start dot";
      msl = "tmuxinator start laptop";
      msm = "tmuxinator start mux";
      msn = "tmuxinator start obsidian";
      mso = "tmuxinator start ofreport";

      "664" = "chmod 664";
      "775" = "chmod 775";

      tt = "tmux attach || tmux new-session -s main";
      ta = "tmux attach -t";
      tn = "tmux new -s";
      tl = "tmux ls";
      tk = "tmux kill-session -t";

      dud = "du -d 1 -h";
      duf = "du -sh *";

      cpv = "rsync -a --no-o --no-g -h --info=progress2 -P";
      cpvr = "rsync -a --no-o --no-g -h --info=progress2 --append";
      clearf = "cat /dev/null >";
      clrf = "cat /dev/null >";

      apti = "sudo apt install -y";
      aptu = "sudo apt update -y";
      aptr = "sudo apt remove -y";
      aptf = "sudo apt full-upgrade -y";
      aptl = "sudo apt list --upgradable";
      di = "sudo dpkg -i";
    };
  };
}
