{ lib, ... }:
let
  bqq = ''if [ $# -eq 0 ]; then bun dev; else bun "$@"; fi'';
  bp = ''bun dev --port "$@"'';
  bi = ''if [ $# -eq 0 ]; then bun i; else bun i "$@"; fi'';
  bid = ''bun i -D "$@"'';
  bg = ''bun i -g "$@"'';
  be = ''bunx "$@"'';
  prettierAll = "bunx prettier --write .";
  deleteNodeModules = "find . -type d -name node_modules -prune -print | xargs rm -rf";
  brf = ''
    find . -type d -name node_modules -prune -print | xargs rm -rf
    rm -f bun.lock bun.lockb
    bun i
  '';
in
{
  den.default.provides.to-users.homeManager.programs = {
    zsh.siteFunctions = {
      inherit
        bqq
        bp
        bi
        bid
        bg
        be
        prettierAll
        deleteNodeModules
        brf
        ;
    };
    bash.bashrcExtra = (
      lib.mkOrder 800 ''
        bqq() {
          ${bqq}
        }

        bp() {
          ${bp}
        }

        bi() {
          ${bi}
        }

        bid() {
          ${bid}
        }

        bg() {
          ${bg}
        }

        be() {
          ${be}
        }

        prettierAll() {
          ${prettierAll}
        }

        deleteNodeModules() {
          ${deleteNodeModules}
        }

        brf() {
          ${brf}
        }
      ''
    );
  };
}
