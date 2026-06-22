{ ... }: {
    programs.nixvim = {
        colorschemes.everforest = {
            enable = true;
            settings = {
                transparent_mode = true;
                background_color = "soft";
            };
        };

        extraConfigLua = ''
            local function set_treesitter_keyword_italics()
              local groups = {
                "@keyword",
                "@keyword.coroutine",
                "@keyword.function",
                "@keyword.operator",
                "@keyword.import",
                "@keyword.type",
                "@keyword.modifier",
                "@keyword.repeat",
                "@keyword.return",
                "@keyword.debug",
                "@keyword.exception",
                "@conditional",
                "@repeat",
              }

              for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, { italic = true })
              end
            end

            set_treesitter_keyword_italics()

            vim.api.nvim_create_autocmd("ColorScheme", {
              callback = set_treesitter_keyword_italics,
            })
        '';
    };

}
