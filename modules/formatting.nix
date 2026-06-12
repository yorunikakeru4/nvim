{pkgs, ...}: let
  prettier = {
    __unkeyed-1 = "prettierd";
    __unkeyed-2 = "prettier";
    stop_after_first = true;
  };
in {
  home.packages = [
    pkgs.prettier
    pkgs.prettierd
  ];

  programs.nixvim.plugins.conform-nvim.settings = {
    formatters_by_ft = {
      sh = ["shfmt"];
      nix = ["nixfmt"];
      just = ["just"];
      lua = ["stylua"];
      go = {
        __unkeyed-1 = "goimports";
        __unkeyed-2 = "gofmt";
        stop_after_first = true;
      };
      rust = {
        __unkeyed-1 = "rustfmt";
        lsp_format = "fallback";
      };
      javascriptreact = prettier;
      javascript = prettier;
      css = prettier;
      html = prettier;
      json = prettier;
      toml = ["taplo"];
      markdown = {
        __unkeyed-1 = "prettierd";
        lsp_format = "fallback";
      };
      python = {
        __unkeyed-1 = "ruff_format";
        __unkeyed-2 = "ruff_organize_imports";
        lsp_format = "fallback";
      };
      php = {
        __unkeyed-1 = "php_cs_fixer";
        stop_after_first = true;
        lsp_format = "fallback";
      };
      c = ["clang_format"];
      cpp = ["clang_format"];
      haskell = ["fourmolu"];
      cabal = ["cabal_fmt"];
      sql = {};
      jsonc = {};
    };

    formatters.clang_format.prepend_args = ["--style=file" "--fallback-style=none"];
    formatters.fourmolu.prepend_args = ["--indentation=4"];
    formatters.nixfmt.prepend_args = ["--indent" "4"];

    format_on_save = ''
      function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "jsonc" or ft == "sql" then
          return
        end

        return {
          async = false,
          lsp_format = "fallback",
        }
      end
    '';
  };
}
