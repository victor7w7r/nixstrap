{
  disko.disk.gpt =
    {
      device,
      partitions,
    }:
    {
      type = "disk";
      device = "/dev/${device}";
      content = {
        type = "gpt";
        inherit partitions;
      };
    };
}
