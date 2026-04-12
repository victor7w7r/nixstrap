{ ... }:

{
  hardware.graphics.enable = true;

  containers.llm = {
    autoStart = true;
    bindMounts."/dev/dri" = {
      hostPath = "/dev/dri";
      isReadOnly = false;
    };

    config =
      { pkgs, ... }:
      {
        hardware.graphics.enable = true;
        hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime ];

        services = {
          open-webui = {
            enable = true;
            port = 3500;
            environment.OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          };

          ollama = {
            enable = true;
            acceleration = "rocm";
            loadModels = [
              "mistral"
              "dolphin-llama3:8b"
              "solar:10.7b"
            ];
          };
        };

        systemd.services.ollama.environment = {
          OLLAMA_INTEL_GPU = "1";
          OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*";
        };

        networking.firewall.allowedTCPPorts = [ 3500 ];
        system.stateVersion = "26.05"; # O la que uses
      };
  };
}
