{
  partitions,
  device ? "sda",
}:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/${device}";
    content = {
      type = "gpt";
      inherit partitions;
    };
  };
}
