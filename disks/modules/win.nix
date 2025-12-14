{
  win = { size ? "100G", name ? "Win" }: {
    inherit name size;
    type = "0700";
  };

  msr = { size ? "16M", name ? "msr" }: {
    inherit name size;
    type = "0C01";
  };

  recovery = { size ? "1G", name ? "Recovery" }: {
    inherit name size;
    type = "2700";
  };
}
