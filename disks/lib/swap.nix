{
  resumeDevice ? true,
  size ? "100%",
  discardPolicy ? "both", # pages, once
}:
{
  inherit size;
  content = {
    type = "swap";
    inherit resumeDevice discardPolicy;
  };
}
