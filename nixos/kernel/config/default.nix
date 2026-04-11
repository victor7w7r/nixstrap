{ host }:
(import ./develop.nix)
++ (import ./common.nix)
++ (import ./intel-amd.nix) { inherit host; }
++ (import ./vendors.nix) { }
++ (import ./cmdline.nix) { inherit host; }
++ (import ./server.nix) { inherit host; }
++ (import ./powersav-perf.nix) { inherit host; }
