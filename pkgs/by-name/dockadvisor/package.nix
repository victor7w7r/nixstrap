{ buildGoModule, inputs }:
buildGoModule {
  pname = "dockadvisor";
  version = "latest";
  src = inputs.dockadvisor;
  vendorHash = "sha256-7nQZekXDzs5VMTKGCcvfMx8nxeyGaPM1dPXGAjyz7Ck=";
}
