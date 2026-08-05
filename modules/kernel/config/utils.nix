{ lib, ... }: {
  kernel.config.utils.setupDenial =
    isDenied: response: lib.mkForce (if isDenied then lib.kernel.no else response);
}
