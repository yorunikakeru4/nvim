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
      -- haskell-scope-highlighting
      require("haskell-scope-highlighting").setup({})
    '';
  };
}
