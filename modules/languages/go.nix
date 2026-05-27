{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.go;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gopls
      golangci-lint-langserver
      gotools
      gosimports
      gomodifytags
      iferr
    ];

    programs.nixvim.plugins.lsp.servers = {
      gopls = {
        enable = true;
        cmd = ["gopls"];
        filetypes = ["go" "gomod"];
        rootMarkers = ["go.mod" "go.work" ".git"];
        settings.gopls = {
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
          semanticTokens = true;
        };
      };

      golangci_lint_ls = {
        enable = true;
        cmd = ["golangci-lint-langserver"];
        filetypes = ["go" "gomod"];
        rootMarkers = ["go.mod" ".git"];
      };
    };

    programs.nixvim.extraConfigLua = ''
      -- gopher.nvim
      require("gopher").setup({})

      -- goplements (show interface implementations)
      require("goplements").setup({})

      -- go-tagger (struct tag generator)
      require("go-tagger").setup({ skip_private = true })

      -- gotests.nvim
      require("gotests").setup()

      -- go-impl.nvim (implement interface, keyed to nf in mappings)
    '';
  };
}
