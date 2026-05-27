{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.shell;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [shfmt];
  };
}
