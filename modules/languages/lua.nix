{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.lua;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [lua-language-server stylua];

    programs.nixvim.plugins.lsp.servers.lua_ls = {
      enable = true;
      cmd = ["lua-language-server"];
      filetypes = ["lua"];
      rootMarkers = [".luarc.json" ".luarc.jsonc" ".git"];
      settings = {
        diagnostics.globals = ["vim"];
      };
    };
  };
}
