{...}: {
  programs.nixvim = {
    opts = {
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99;
    };

    globals = {
      markdown_folding = 1;
      markdown_syntax_conceal = 1;
      vim_markdown_conceal_code_blocks = 1;
    };

    diagnostic.settings = {
      signs = {
        text = [" " " " " " " "];
        numhl = [
          "DiagnosticSignError"
          "DiagnosticSignWarn"
          "DiagnosticSignInfo"
          "DiagnosticSignHint"
        ];
      };
      underline = true;
      update_in_insert = false;
      severity_sort = true;
      virtual_text = true;
    };

    autoGroups.markdown.clear = true;

    autoCmd = [
      {
        event = "FileType";
        pattern = "markdown";
        group = "markdown";
        command = "setlocal foldmethod=syntax";
      }
    ];

    extraConfigLua = ''
      -- Rainbow delimiters
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = { [""] = 110, lua = 210 },
        highlight = {
          "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
          "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    '';
  };
}
