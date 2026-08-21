{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "ssh-list";
  src = inputs.ssh-list;
})
