{ host }:
(
  if host == "v7w7r-macmini81" then
    import ./macminiconfig.x86_64-linux.nix
  else if host == "v7w7r-youyeetoox1" then
    import ./serverconfig.x86_64-linux.nix
  else if host == "v7w7r-rc71l" then
    import ./rogallyconfig.x86_64-linux.nix
  else
    import ./higoleconfig.x86_64-linux.nix
)
