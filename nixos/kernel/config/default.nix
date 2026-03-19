{ host }:
(import ./develop.nix)
++ (import ./common.nix)
++ (import ./intel-amd.nix) { inherit host; }
++ (
  if host == "v7w7r-macmini81" then
    [ "--set-str X86_64_VERSION 3" ]
  else if host == "v7w7r-youyeetoox1" || host == "v7w7r-youyeetoox1" then
    [ "--set-str X86_64_VERSION 2" ]
  else
    [ ]
)
++ (import ./vendors.nix)
++ (import ./cmdline.nix) { inherit host; }
++ (import ./server.nix) { inherit host; }
++ (import ./powersav-perf.nix) { inherit host; }
