{ inputs, lib, ... }:
let
  instantiatePkgs = { hostSystem, targetSystem }:
    let
      configArgs = if hostSystem == targetSystem then {
        system = targetSystem;
      } else {
        localSystem = hostSystem;
        crossSystem = targetSystem;
      };
    in
      builtins.tryEval (import inputs.nixpkgs configArgs);

  getInjectPkgs = { hostSystem, primaryTarget, fallbackTarget }:
    let
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
in
{

  injectPkgs = getInjectPkgs {
    hostSystem = "aarch64-linux";
    primaryTarget = "x86_64-linux";
    fallbackTarget = "aarch64-linux";
  };
}
