{ host }:
(import ./develop.nix)
++ (import ./common.nix)
++ (import ./cmdline.nix) { inherit host; }
++ (import ./intel-amd.nix) { inherit host; }
++ (import ./vendors.nix)
++ (import ./server.nix) { inherit host; }
++ (import ./powersav-perf.nix) { inherit host; }
