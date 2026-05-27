{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.python;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      basedpyright
      ruff
    ];

    programs.nixvim.plugins.lsp.servers = {
      basedpyright = {
        enable = true;
        settings.basedpyright.analysis = {
          typecheckingmode = "off";
          strictdictionaryinference = false;
          strictlistinference = false;
          reportprivateusage = "none";
          reportunknownvariabletype = "none";
          inlayhints = {
            variabletypes = true;
            functionreturntypes = true;
            callargumentnames = true;
          };
        };
      };
      ruff = {
        enable = true;
        cmd = ["ruff" "server"];
        filetypes = ["python"];
        rootMarkers = ["pyproject.toml" "ruff.toml" ".ruff.toml" ".git"];
      };
    };
  };
}
