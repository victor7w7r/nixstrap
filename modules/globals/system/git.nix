{
  den.default = {
    os =
      {
        isPersistent,
        lib,
        pkgs,
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          [
            delta
            git
            git-lfs
          ]
          ++ lib.optionals isPersistent [
            github-copilot-cli
            gh
            gh-dash
            git-extras
            hub
            zsh-forgit
          ];
      };

    provides.to-users.homeManager =
      {
        isPersistent,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = with pkgs; [ lazygit ] ++ lib.optionals isPersistent [ git-credential-manager ];
        programs = {
          git = {
            enable = true;
            package = pkgs.gitFull;
            ignores = [
              "*~"
              "*.swp"
              ".DS_Store"
              ".devenv"
            ];
            attributes = [ "*.pdf diff=pdf" ];
            lfs.enable = true;
            settings = {
              alias = {
                unstash = "stash pop";
                s = "status";
                tags = "tag -l";
                t = "tag -s -m ''";
                commit-reuse-message = ''!git commit --edit --file "$(git rev-parse --git-dir)"/COMMIT_EDITMSG'';
                br = "branch";
                co = "checkout";
                st = "status";
                ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
                ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
                cm = "commit -m";
                ca = "commit -am";
                dc = "diff --cached";
                amend = "commit --amend -m";

              };
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
            };
          };
          difftastic = {
            enable = true;
            git.enable = true;
            options.background = "dark";
          };
        };
      };
  };
}
