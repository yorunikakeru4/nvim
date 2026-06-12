{...}: {
  programs.nixvim = {
    plugins.gitsigns.settings = {
      current_line_blame = true;
      signs = {
        add.text = "+";
        change.text = "~";
        delete.text = "-";
        topdelete.text = "-";
        changedelete.text = "~";
        untracked.text = "+";
      };
    };

    highlightOverride = {
      GitSignsAdd = {
        fg = "#22c55e";
        ctermfg.__raw = "40";
      };
      GitSignsChange = {
        fg = "#eab308";
        ctermfg.__raw = "184";
      };
    };

    extraConfigLua = ''
      require("atlas").setup({
        pulls = {
          diff = { open_cmd = "DiffviewOpen" },
          providers = { github = {} },
        },
        issues = {
          providers = { github = {} },
        },
      })
    '';
  };
}
