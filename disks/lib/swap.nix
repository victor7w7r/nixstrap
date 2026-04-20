{
  resumeDevice ? true,
  size ? "8G",
  discardPolicy ? "both", # pages, once
}:
{
  inherit size;
  content = {
    type = "swap";
    inherit resumeDevice discardPolicy;
  };
}
