{
    pkgs,
    lib,
    config,
    ...
}:
{
    imports = [
        ./languages.nix
        ./plugins.nix
        ./lsp.nix
        ./completion.nix
        ./formatting.nix
        ./treesitter.nix
        ./theme.nix
        ./keymaps.nix
        ./switchboard.nix
        ./plugin-configs
        ./languages/go.nix
        ./languages/rust.nix
        ./languages/python.nix
        ./languages/nix.nix
        ./languages/lua.nix
        ./languages/php.nix
        ./languages/elixir.nix
        ./languages/cpp.nix
        ./languages/haskell.nix
        ./languages/docker.nix
        ./languages/markdown.nix
        ./languages/sql.nix
        ./languages/just.nix
        ./languages/toml.nix
        ./languages/shell.nix
        ./languages/yaml.nix
    ];

    programs.nixvim = {
        enable = true;
        defaultEditor = true;

        opts = {
            number = true;
            relativenumber = true;
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            termguicolors = true;
            mouse = "";
            clipboard = "unnamedplus";
            laststatus = 3;
            showmode = false;
            pumheight = 7;
            swapfile = false;
            undofile = true;
            ignorecase = true;
            smartcase = true;
            incsearch = true;
            hlsearch = true;
            scrolloff = 8;
            cursorline = true;
            cursorlineopt = "number";
            signcolumn = "yes";
            updatetime = 200;
            timeoutlen = 800;
            synmaxcol = 240;
            confirm = true;
            hidden = true;
            wrap = true;
            linebreak = true;
            breakindent = true;
            showbreak = "↳ ";
            breakat = "!@-/\\ ";
            fillchars = {
                eob = " ";
            };
            completeopt = [
                "menu"
                "menuone"
                "noselect"
            ];
            grepprg = "rg --vimgrep";
            spell = true;
            spelllang = [
                "en"
                "ru"
            ];
            shell = "fish";
        };

        globals.mapleader = " ";

        extraConfigLua = ''
            local function show_default_intro()
              local is_empty_start = vim.fn.argc(-1) == 0
                and vim.api.nvim_buf_get_name(0) == ""
                and vim.api.nvim_buf_line_count(0) == 1
                and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ""

              if is_empty_start then
                vim.opt.shortmess:remove("I")
                vim.cmd("silent! intro")
              end
            end

            vim.api.nvim_create_autocmd("VimEnter", {
              group = vim.api.nvim_create_augroup("DefaultIntro", { clear = true }),
              callback = show_default_intro,
            })
        '';
    };
}
