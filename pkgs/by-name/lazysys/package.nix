{ buildGoModule, inputs }:
buildGoModule {
  pname = "lazysys";
  version = "latest";
  src = inputs.lazysys;
  vendorHash = "sha256-17DJNut4otpI1DV42P1XvPe8Ny+E7ETsfyNXRkknS/A=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
