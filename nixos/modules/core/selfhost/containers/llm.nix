{ ... }:

{
  hardware.graphics.enable = true;

  containers.llm = {
    autoStart = false;
    privateNetwork = true;
    hostBridge = "brint";
    localAddress = "10.10.0.4/24";
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
      { pkgs, lib, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 3500 ];
        system.stateVersion = "26.05";
        hardware.graphics = {
          enable = true;
          extraPackages = [ pkgs.intel-compute-runtime ];
        };

        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "open-webui"
          ];

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
