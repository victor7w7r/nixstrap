{ lib, ... }: {
  kernel.config.utils = {
    setupDenial = isDenied: response: if isDenied then lib.kernel.no else response;
  };
}
