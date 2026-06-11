{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.docker;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [dockerfile-language-server docker-compose-language-service hadolint];

    programs.nixvim.plugins.lint.lintersByFt.dockerfile = ["hadolint"];

    programs.nixvim = {
      filetype.filename = {
        "compose.yaml" = "yaml.docker-compose";
        "compose.yml" = "yaml.docker-compose";
        "docker-compose.yaml" = "yaml.docker-compose";
        "docker-compose.yml" = "yaml.docker-compose";
      };

      plugins.lsp.servers = {
        dockerls = {
          enable = true;
          filetypes = ["dockerfile"];
          rootMarkers = ["Dockerfile" ".git"];
        };
        docker_compose_language_service = {
          enable = true;
          cmd = ["docker-compose-langserver" "--stdio"];
        };
      };
    };
  };
}
