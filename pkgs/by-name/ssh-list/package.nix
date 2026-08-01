{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "ssh-list";
  src = inputs.ssh-list;
})
