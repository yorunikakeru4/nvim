{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.toml;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [taplo];

    programs.nixvim.plugins.lsp.servers.taplo = {
      enable = true;
      cmd = ["taplo" "lsp" "stdio"];
      filetypes = ["toml"];
      rootMarkers = [".git" "taplo.toml" ".taplo.toml"];
    };
  };
}
