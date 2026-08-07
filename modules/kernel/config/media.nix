{ lib, ... }: {
  kernel.config.media = with lib.kernel; {
  };
}
