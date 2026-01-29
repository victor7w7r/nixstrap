{
  postHook ? null,
  priority ? 4,
  vg ? "vg0",
  size ? "100%",
}:
{
  content = {
    inherit size priority vg;
    type = "lvm_pv";
  };
  postCreateHook = if (postHook != null) then postHook else "";
}
