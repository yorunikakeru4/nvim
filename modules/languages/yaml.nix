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
        validate = true;
        schemas = {
          "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.{yml,yaml}";
          "https://json.schemastore.org/github-action.json" = ".github/action.{yml,yaml}";
          "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "{docker-compose,compose}.{yml,yaml}";
          "https://json.schemastore.org/helmfile.json" = "helmfile.{yml,yaml}";
          "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0/all.json" = "k8s/*.{yml,yaml}";
          "https://json.schemastore.org/golangci-lint.json" = ".golangci.{yml,yaml}";
          "https://json.schemastore.org/pre-commit-config.json" = ".pre-commit-config.{yml,yaml}";
        };
      };
    };
  };
}
