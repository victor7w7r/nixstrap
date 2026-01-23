{
  win =
    {
      size ? "100G",
      name ? "Win",
      priority ? 5,
    }:
    {
      inherit name size priority;
      type = "0700";
    };

  msr =
    {
      size ? "16M",
      name ? "msr",
    }:
    {
      inherit name size;
      priority = 2;
      type = "0C01";
    };

  recovery =
    {
      size ? "1G",
      name ? "Recovery",
    }:
    {
      inherit name size;
      priority = 4;
      type = "2700";
    };
}
