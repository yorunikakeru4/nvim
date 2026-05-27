{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.yaml;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [yaml-language-server];

    programs.nixvim.plugins.lsp.servers.yamlls = {
      enable = true;
      cmd = ["yaml-language-server" "--stdio"];
      filetypes = ["yaml" "yaml.docker-compose"];
      rootMarkers = [".git"];
      settings.yaml = {
        schemas = {};
        validate = true;
      };
    };
  };
}
