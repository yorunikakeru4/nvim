{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.sql;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [sqls];

    programs.nixvim.plugins.lsp.servers.sqls = {
      enable = true;
      cmd = ["sqls"];
      filetypes = ["sql"];
    };
  };
}
