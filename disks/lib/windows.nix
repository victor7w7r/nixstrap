{
  win =
    {
      name ? "win",
      priority ? 5,
      size ? "100G",
    }:
    {
      inherit name size priority;
      type = "0700";
    };

  msr =
    {
      priority ? 2,
    }:
    {
      inherit priority;
      type = "0C01";
      name = "msr";
      size = "16M";
    };

  recovery =
    {
      name ? "winrecovery",
      priority ? 4,
    }:
    {
      inherit name priority;
      type = "2700";
      size = "1G";
    };
}
