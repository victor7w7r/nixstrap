{ host }:
(import ./common.nix)
++ (
  if host == "v7w7r-youyeetoox1" then
    (import ./server.nix)
  else
    (
      (if host == "v7w7r-higole" then (import ./higole.nix) else (import ./responsive.nix))
      ++ (import ./general.nix)
    )
)
++ (if host == "v7w7r-rc71l" then (import ./asus-amd.nix) else (import ./intel.nix))
++ (import ./debug.nix)
++ (import ./net.nix)
++ (import ./vendors.nix)
++ (import ./trace.nix)
