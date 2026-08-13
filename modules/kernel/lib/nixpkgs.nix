{ inputs, kernel, ... }:
{
  kernel.lib = {
    nixpkgs =
      {
        hostSystem,
        primaryTarget,
        fallbackTarget,
      }:
      let
        instantiatePkgs =
          { hostSystem, targetSystem }:
          builtins.tryEval (
            import inputs.nixpkgs (
              if hostSystem == targetSystem then
                {
                  system = targetSystem;
                }
              else
                {
                  localSystem = hostSystem;
                  crossSystem = targetSystem;
                }
            )
          );

        primaryAttempt = instantiatePkgs {
          inherit hostSystem;
          targetSystem = primaryTarget;
        };

        fallbackAttempt = instantiatePkgs {
          inherit hostSystem;
          targetSystem = fallbackTarget;
        };
      in
      if primaryAttempt.success then
        primaryAttempt.value
      else if fallbackAttempt.success then
        builtins.trace "WARNING: Fallback activated from ${primaryTarget} to ${fallbackTarget}" fallbackAttempt.value
      else
        throw "ERROR: Failed (${primaryTarget} and ${fallbackTarget})";

    armInjectPkgs = kernel.lib.nixpkgs {
      hostSystem = "aarch64-linux";
      primaryTarget = "x86_64-linux";
      fallbackTarget = "aarch64-linux";
    };

    x86InjectPkgs = kernel.lib.nixpkgs {
      hostSystem = "x86_64-linux";
      primaryTarget = "aarch64-linux";
      fallbackTarget = "x86_64-linux";
    };
  };
}
