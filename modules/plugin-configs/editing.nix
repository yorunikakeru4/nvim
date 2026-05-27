{...}: {
  programs.nixvim.extraConfigLua = ''
    -- nvim-autopairs extra rules
    local npairs = require("nvim-autopairs")
    local Rule  = require("nvim-autopairs.rule")
    local cond  = require("nvim-autopairs.conds")
    npairs.add_rules({ Rule("<", ">", { "html", "markdown" }):with_pair():with_move(cond.done()) })
    npairs.add_rules({ Rule("|", "|", { "rust", "markdown" }):with_pair() })

    -- hbac (auto-close old buffers, threshold=10)
    require("hbac").setup({
      autoclose = true,
      threshold = 10,
    })

    -- vim-matchup
    vim.g.matchup_treesitter_stopline = 500
  '';

  programs.nixvim.plugins = {
    nvim-surround.settings.keymaps.visual = "s";
    comment.settings = {
      toggler = {
        line = "<A-q>";
        block = "<A-qq>";
      };
      opleader.block = "<A-q>";
    };
  };
}
