{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.srcs-pypi-update;
in {
  options.services.srcs-pypi-update = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, NixOS will periodically update the repository.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "hourly";
      example = "hourly";
      description = ''
        Run the script at this interval.
        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

  };

  config = {
    systemd.services.srcs-pypi-update = {
      description = "Update Locate Database";
      script = "./srcs-pypi-update"
    };

    systemd.timers.srcs-pypi-update = mkIf cfg.enable {
      description = "Update timer for locate database";
      partOf      = [ "srcs-pypi.update.service" ];
      wantedBy    = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.interval;
    };
  };
}
