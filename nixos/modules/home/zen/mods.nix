{ inputs, ... }:
{
  programs.zen-browser.profiles.default.sine = {
    enable = true;
    mods = [
      "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
      "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
      "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
      "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
      "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
      "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
      "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
      "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
      "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
      "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better Active Tab
      "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
      "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
      "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e" # Quietify
    ];
  };

  programs.zen-browser.profiles.default.mods = [
    "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
    "ae7868dc-1fa1-469e-8b89-a5edf7ab1f24" # Load Bar
    "599a1599-e6ab-4749-ab22-de533860de2c" # Pimp your PiP
    "e51b85e6-cef5-45d4-9fff-6986637974e1" # smaller zen toast popup
    "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
    "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
    "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
  ];
}
