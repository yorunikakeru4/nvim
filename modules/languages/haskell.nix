{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.haskell;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [haskell-language-server ormolu];

    programs.nixvim.plugins.lsp.servers.hls = {
      enable = true;
      installGhc = false;
      cmd = ["haskell-language-server-wrapper" "--lsp"];
      filetypes = ["haskell" "lhaskell" "cabal"];
      rootMarkers = ["*.cabal" "stack.yaml" "cabal.project" "package.yaml" "hie.yaml" ".git"];
      settings.haskell = {
        formattingProvider = "ormolu";
        checkProject = true;
        plugin.stan.globalOn = true;
      };
    };

    programs.nixvim.extraConfigLua = ''
      -- haskell-scope-highlighting (patch nil scope_matches bug upstream)
      local _hs_ts = require("haskell-scope-highlighting.treesitter")
      local _orig_caps = _hs_ts.captures_at_point_sorted
      _hs_ts.captures_at_point_sorted = function(...)
        local bufnr, matches = _orig_caps(...)
        return bufnr, matches or {}
      end
      require("haskell-scope-highlighting").setup({})
    '';
  };
}
