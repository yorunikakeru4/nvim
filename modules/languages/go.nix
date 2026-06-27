{
    lib,
    pkgs,
    config,
    ...
}:
let
    cfg = config.nixvimLanguages.go;
in
{
    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            gopls
            golangci-lint-langserver
            gotools
            gosimports
            gomodifytags
            iferr
            impl
            delve
        ];

        programs.nixvim.plugins.lsp.servers = {
            gopls = {
                enable = true;
                cmd = [ "gopls" ];
                filetypes = [
                    "go"
                    "gomod"
                ];
                rootMarkers = [
                    "go.mod"
                    "go.work"
                    ".git"
                ];
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
                cmd = [ "golangci-lint-langserver" ];
                filetypes = [
                    "go"
                    "gomod"
                ];
                rootMarkers = [
                    "go.mod"
                    ".git"
                ];
            };
        };

        programs.nixvim.extraConfigLua = ''
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "go",
              group = vim.api.nvim_create_augroup("GoLazyHelpers", { clear = true }),
              callback = function()
                vim.cmd.packadd("gopher-nvim")
                vim.cmd.packadd("goplements-nvim")
                vim.cmd.packadd("go-tagger-nvim")
                vim.cmd.packadd("gotests-nvim")
                vim.cmd.packadd("nvim-dap-go")

                require("gopher").setup({})
                require("goplements").setup({})
                require("go-tagger").setup({ skip_private = true })
                require("gotests").setup()
                require("dap-go").setup({
                  dap_configurations = {
                    {
                      type = "go",
                      name = "Attach remote",
                      mode = "remote",
                      request = "attach",
                    },
                  },
                  delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                    args = {},
                    build_flags = {},
                  },
                })
              end,
            })
        '';
    };
}
