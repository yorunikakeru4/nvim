{ ... }: {
    programs.nixvim.extraConfigLua = ''
        require('boolean-toggle').setup({
            keymaps = {
            toggle = '<CR>', -- Toggle on ENTER
            to_false = '<BS>', -- Set to `false` by pressing Backspace
            to_true = '<C-BS>', -- Set to `false` by pressing CTRL + Backspace
            },
        })

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

        -- nvim-surround v4: keymaps are no longer configured via setup().
        vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", {
          desc = "Add a surrounding pair around a visual selection",
        })
    '';

    programs.nixvim.plugins = {
        comment.settings = {
            toggler = {
                line = "<A-q>";
                block = "<A-qq>";
            };
            opleader.block = "<A-q>";
        };
    };
}
