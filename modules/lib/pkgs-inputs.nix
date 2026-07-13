{
  flake-file.inputs = {
    xrlinux = {
      url = "github:wheaney/XRLinuxDriver";
      flake = false;
    };

    adb_shell = {
      url = "github:JeffLIrion/adb_shell";
      flake = false;
    };
  };
}
