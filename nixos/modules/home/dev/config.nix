{ pkgs, ... }:
{
  programs = {
    difftastic = {
      enable = true;
      git.enable = true;
      options.background = "dark";
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "victor7w7r";
      userEmail = "arkano036@gmail.com";
      settings = {
        core.pager = "${pkgs.delta}/bin/delta";
        init.defaultBranch = "main";
        credential.helper = "store";
        delta = {
          hyperlinks = true;
          keep-plus-minus-markers = true;
          line-numbers = true;
          navigate = true;
          side-by-side = true;
          syntax-theme = "TwoDark";
          tabs = 4;
        };
        difftool.prompt = true;
        merge.conflictstyle = "diff3";
        mergetool.prompt = true;
        rebase.autostash = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
        alias = {
          unstash = "stash pop";
          s = "status";
          tags = "tag -l";
          t = "tag -s -m ''";
          fixup = ''!f() { TARGET=$(git rev-parse "$1"); git commit --fixup=$TARGET ''${@:2} && EDITOR=true git rebase -i --gpg-sign --autostash --autosquash $TARGET^; }; f'';
          commit-reuse-message = ''!git commit --edit --file "$(git rev-parse --git-dir)"/COMMIT_EDITMSG'';
        };
      };
    };

    gitui.enable = true;
    jq.enable = true;
    lazysql.enable = true;
    #meli.enable = true; BUILD
    mods.enable = true;
    visidata.enable = true;
  };
}
