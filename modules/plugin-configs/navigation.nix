{ ... }: {
    programs.nixvim = {
        plugins = {
            nvim-tree.settings = {
                on_attach.__raw = ''
                    function(bufnr)
                      local api = require("nvim-tree.api")
                      api.config.mappings.default_on_attach(bufnr)
                      vim.keymap.set("n", "?", api.tree.toggle_help, { buffer = bufnr, noremap = true, silent = true })
                      vim.keymap.set("n", "<leader>d", api.tree.change_root_to_node, { buffer = bufnr, noremap = true, silent = true })
                    end
                '';
                view = {
                    width = 50;
                    side = "left";
                };
                live_filter.always_show_folders = true;
                renderer = {
                    group_empty = true;
                    root_folder_label = ":~:s?$?/..?";
                    icons.show = {
                        file = true;
                        folder = true;
                        folder_arrow = true;
                        git = true;
                        modified = true;
                        hidden = true;
                    };
                };
                actions.change_dir = {
                    enable = true;
                    global = true;
                    restrict_above_cwd = false;
                };
                sync_root_with_cwd = true;
            };

        };

        extraConfigLua = ''
            -- outline
            require("outline").setup({
              outline_window = { position = "right", relative_width = false, width = 40,
                                 focus_on_open = true, show_numbers = false,
                                 show_relative_numbers = true },
              preview_window = { auto_preview = true },
              symbol_folding = { autofold_depth = nil },
            })

            local trouble_configured = false
            local function ensure_trouble()
              vim.cmd.packadd("trouble.nvim")
              local trouble = require("trouble")
              if not trouble_configured then
                trouble.setup({
                  auto_close = false,
                  auto_open = false,
                  auto_preview = true,
                  auto_refresh = true,
                  focus = true,
                  follow = true,
                  win = { position = "right", size = 40 },
                  modes = {
                    diagnostics = {
                      groups = {
                        { "directory" },
                        { "filename", format = "{file_icon} {basename} {count}" },
                      },
                    },
                  },
                })
                trouble_configured = true
              end
              return trouble
            end

            local telescope_configured = false
            function _G.nixvim_telescope_builtin()
              vim.cmd.packadd("telescope.nvim")
              vim.cmd.packadd("telescope-fzf-native.nvim")
              local telescope = require("telescope")
              if not telescope_configured then
                telescope.setup({
                  defaults = {
                    layout_strategy = "flex",
                    layout_config = {
                      width = 0.95,
                      height = 0.9,
                      horizontal = {
                        prompt_position = "top",
                        preview_width = 0.58,
                        preview_cutoff = 1,
                      },
                      vertical = {
                        prompt_position = "top",
                        preview_height = 0.55,
                        preview_cutoff = 1,
                      },
                      flex = { flip_columns = 120 },
                    },
                    sorting_strategy = "ascending",
                    dynamic_preview_title = true,
                    path_display = { "smart" },
                    winblend = 0,
                    preview = { hide_on_startup = false },
                  },
                  pickers = {
                    find_files = { previewer = true },
                    git_files = { previewer = true },
                    live_grep = { previewer = true },
                    grep_string = { previewer = true },
                  },
                })
                pcall(telescope.load_extension, "fzf")
                telescope_configured = true
              end
              return require("telescope.builtin")
            end

            function _G.toggle_outline_sidebar()
              pcall(function() ensure_trouble().close() end)
              vim.cmd("Outline")
            end

            function _G.toggle_trouble_sidebar()
              vim.cmd("OutlineClose")
              ensure_trouble().toggle({ mode = "diagnostics", focus = true })
            end

            local seeker_configured = false
            local function ensure_seeker()
              _G.nixvim_telescope_builtin()
              if not seeker_configured then
                require("seeker").setup({
                  picker_provider = "telescope",
                  picker_opts = {
                    layout_strategy = "flex",
                    layout_config = {
                      width = 0.95, height = 0.9,
                      horizontal = { prompt_position = "top", preview_width = 0.58, preview_cutoff = 1 },
                      vertical   = { prompt_position = "top", preview_height = 0.55, preview_cutoff = 1 },
                      flex = { flip_columns = 120 },
                    },
                    sorting_strategy = "ascending",
                    dynamic_preview_title = true,
                    path_display = { "smart" },
                    previewer = true,
                  },
                })
                seeker_configured = true
              end
            end

            vim.keymap.set("n", "<leader>fa", function()
              ensure_seeker()
              vim.cmd("Seeker files")
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<leader>fw", function()
              ensure_seeker()
              vim.cmd("Seeker grep_word")
            end, { noremap = true, silent = true })
        '';
    };
}
