{
  resumeDevice ? true,
  size ? "8G",
  discardPolicy ? "both", # pages, once
}:
{
  inherit size;
  # > 4GB RAM = 8GB SWAP
  # 4GB - 8GB = 4GB SWAP
  # 8GB - 16GB = 8GB SWAP
  # 32GB = 2GB SWAP
  content = {
    type = "swap";
    inherit resumeDevice discardPolicy;
  };
}
