{
  content,
  group ? "vg0",
  thin_size ? "100%",
  thin_name ? "thinpool",
}:
{
  lvm_vg."${group}" = {
    type = "lvm_vg";
    lvs = {
      ${thin_name} = {
        size = thin_size;
        lvm_type = "thin-pool";
      };
    }
    // content;
  };
}
