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
      settings = {
        core.pager = "${pkgs.delta}/bin/delta";
        init.defaultBranch = "main";
        user = {
          name = "victor7w7r";
          email = "arkano036@gmail.com";
        };
        #credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
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
          commit-reuse-message = ''!git commit --edit --file "$(git rev-parse --git-dir)"/COMMIT_EDITMSG'';
        };
      };
    };

    gitui.enable = true;
    jq.enable = true;
    lazysql.enable = true;
    mise = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      globalConfig = {
        tools = {
          bun = "1.3";
          node = "24";
        };
        settings = {
          trusted_config_paths = [ "~/repositories" ];
          node.compile = false;
          npm.bun = true;
        };
      };
    };
    #meli.enable = true; BUILD
    mods.enable = true;
    visidata.enable = true;
  };
}
