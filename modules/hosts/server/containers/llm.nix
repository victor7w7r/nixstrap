{ containers, ... }:
{
  den.aspects.server.provides.containers.nixos = { pkgs, lib, ... }: {
    containers.llm = containers.lib.call {
      ip = "5";
      name = "llm";
      
      bindMounts = {
        "/dev/dri" = {
          hostPath = "/dev/dri";
          isReadOnly = false;
        };
      };

      extra = {
        hardware.graphics = {
          enable = true;
          extraPackages = [ pkgs.intel-compute-runtime ];
        };
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "open-webui" ];
      };

      services = _: __: {
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

      systemd = pkgs: {
        ollama.environment = {
          OLLAMA_INTEL_GPU = "1";
          OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*";
        };
        funnel = containers.lib.funnel {
          inherit pkgs;
          outgoing = "443";
          incoming = "3500";
        };
      };
    };
  };
}
