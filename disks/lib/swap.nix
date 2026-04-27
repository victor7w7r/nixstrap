{
  resumeDevice ? true,
  size ? "100%",
  discardPolicy ? "both", # pages, once
}:
{
  type = "swap";
  inherit resumeDevice discardPolicy;
}
