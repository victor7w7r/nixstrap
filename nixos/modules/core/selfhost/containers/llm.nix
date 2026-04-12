{ ... }:

{
  hardware.graphics.enable = true;

  containers.llm = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.123/24";
    forwardPorts = [
      {
        containerPort = 3500;
        hostPort = 3500;
        protocol = "tcp";
      }
    ];
    bindMounts."/dev/dri" = {
      hostPath = "/dev/dri";
      isReadOnly = false;
    };

    config =
      { pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 3500 ];
        system.stateVersion = "26.05";
        hardware.graphics = {
          enable = true;
          extraPackages = [ pkgs.intel-compute-runtime ];
        };

        systemd.services.ollama.environment = {
          OLLAMA_INTEL_GPU = "1";
          OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*";
        };

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
      };
  };
}
