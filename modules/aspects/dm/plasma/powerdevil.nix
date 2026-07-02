{
  den.aspects.plasma.powerdevil.provides.to-users.homeManager =
    { isMain, ... }:
    {
      programs.plasma.powerdevil = {
        general.pausePlayersOnSuspend = true;
        batteryLevels = {
          criticalAction = "hibernate";
          criticalLevel = 5;
          lowLevel = 10;
        };
        AC = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = if isMain then 10800 else 3600;
          };
          turnOffDisplay = {
            idleTimeout = if isMain then 3600 else 180;
            idleTimeoutWhenLocked = 40;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = if isMain then 300 else 120;
          };
          powerButtonAction = "sleep";
          whenLaptopLidClosed = "sleep";
        };
        battery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 300;
          };
          turnOffDisplay = {
            idleTimeout = 60;
            idleTimeoutWhenLocked = 20;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 45;
          };
          powerButtonAction = "sleep";
          whenLaptopLidClosed = "sleep";
        };
        lowBattery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 60;
          };
          turnOffDisplay = {
            idleTimeout = 30;
            idleTimeoutWhenLocked = "immediately";
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 25;
          };
          powerButtonAction = "hibernate";
          whenLaptopLidClosed = "sleep";
        };
      };
    };
}
