{
    pkgs,
    nvimFlakeInputs,
    ...
}:
let
    custom = nvimFlakeInputs.nvim-plugins.packages.${pkgs.stdenv.hostPlatform.system};
in
{
    home.packages = with pkgs; [
        nodejs_22
        tree-sitter
    ];

    programs.nixvim = {
        plugins = {
            treesitter = {
                enable = true;
                settings = {
                    auto_install = true;
                    highlight.enable = true;
                };
            };
            lsp.enable = true;
            cmp.enable = true;
            luasnip.enable = true;
            conform-nvim.enable = true;
            nvim-tree.enable = true;
            gitsigns.enable = true;
            toggleterm.enable = true;
            comment.enable = true;
            nvim-autopairs.enable = true;
            nvim-surround.enable = true;
            todo-comments.enable = true;
            fidget.enable = true;
            lualine.enable = true;
            indent-blankline.enable = true;
            flash.enable = true;
            diffview.enable = true;
            undotree.enable = true;
            lz-n.enable = true;
            mini-icons = {
                enable = true;
                mockDevIcons = true;
            };
        };

        extraPlugins = with pkgs.vimPlugins; [
            plenary-nvim
            everforest
            gruvbox-baby
            gruvbox-material
            rainbow-delimiters-nvim
            vim-matchup
            nvim-cokeline
            gx-nvim
            vim-fugitive
            lazygit-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip
            friendly-snippets
            cmp-dotenv
            nix-develop-nvim
            outline-nvim
            # misc
            nvim-jqx
            # custom plugins (from nvim-plugins sub-flake)
            custom.hbac-nvim
            custom.vim-autoread
            custom.seeker-nvim
            custom.signup-nvim
            custom.markdown-plus-nvim
            custom.vim-highlighturl
            custom.vim-php-cs-fixer
            custom.switchboard-nvim
            custom.atlas-nvim
            custom.match-nvim
            custom.boolean-toggle
            # dap helpers
            nvim-dap-virtual-text
            nvim-dap-python
            {
                plugin = telescope-nvim;
                optional = true;
            }
            {
                plugin = telescope-fzf-native-nvim;
                optional = true;
            }
            {
                plugin = trouble-nvim;
                optional = true;
            }
            {
                plugin = custom.gopher-nvim;
                optional = true;
            }
            {
                plugin = custom.gotests-nvim;
                optional = true;
            }
            {
                plugin = custom.goplements-nvim;
                optional = true;
            }
            {
                plugin = custom.go-tagger-nvim;
                optional = true;
            }
            {
                plugin = nvim-dap-go;
                optional = true;
            }
        ];
    };
}
