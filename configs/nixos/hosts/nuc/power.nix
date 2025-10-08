{ ... }:

{
  # Disable hibernation/sleep to keep SSH available
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    IdleAction=ignore
  '';
}
