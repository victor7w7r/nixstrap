{ buildGoModule, inputs }:
buildGoModule {
  pname = "cemetery-escape";
  version = "main";
  src = inputs.cemetery-escape;
  vendorHash = "sha256-/yOpyvbt+H7AQLXn2gp+6JRaLTDR3hBznOq5L1DUUUQ=";
  ldflags = [
    "-s"
    "-w"
  ];
}
