{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.markdown;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [marksman proselint];

    programs.nixvim.plugins.lsp.servers.marksman = {
      enable = true;
      cmd = ["marksman" "server"];
      filetypes = ["markdown"];
      rootMarkers = [".marksman.toml" ".git"];
    };

    programs.nixvim.globals = {
      vimtex_view_method = "zathura";
      vimtex_compiler_method = "latexmk";
    };

    programs.nixvim.extraConfigLua = ''
      -- markdown-plus
      require("markdown-plus").setup({})
    '';
  };
}
