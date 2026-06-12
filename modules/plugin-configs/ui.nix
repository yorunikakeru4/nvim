{ ... }: {
    programs.nixvim = {
        plugins = {
            ccc = {
                enable = true;
                settings.highlighter = {
                    auto_enable = true;
                    lsp = true;
                };
            };

            image.enable = true;

            render-markdown = {
                enable = true;
                settings = {
                    latex = {
                        enabled = false;
                    };
                };
            };

            treesitter-context = {
                enable = true;
                settings = {
                    mode = "cursor";
                    max_lines = 2;
                };
            };
        };

        extraConfigLua = ''
            -- profile.nvim dashboard
            require("profile").setup({
              user = "yorunikakeru4",
              avatar_path = "${../../pictures/kim.png}",
            })
            vim.keymap.set("n", "<leader>p", "<cmd>Profile<cr>", { silent = true })
            vim.api.nvim_create_autocmd("VimEnter", {
              group = vim.api.nvim_create_augroup("ProfileDashboard", { clear = true }),
              callback = function()
                if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
                  vim.cmd("Profile")
                end
              end,
            })

            require("match").setup()
            require("render-markdown.state").config.conceal = nil

            -- cokeline
            local cokeline_colors = {
              active_bg = "#3c3836",
              active_fg = "#fabd2f",
              inactive_bg = "NONE",
              inactive_fg = "#928374",
              prefix = "#665c54",
              close = "#ea6962",
            }

            require("cokeline").setup({
              default_hl = {
                fg = function(buffer)
                  return buffer.is_focused and cokeline_colors.active_fg or cokeline_colors.inactive_fg
                end,
                bg = function(buffer)
                  return buffer.is_focused and cokeline_colors.active_bg or cokeline_colors.inactive_bg
                end,
              },

              components = {
                {
                  text = function(buffer) return " " .. buffer.devicon.icon end,
                  fg = function(buffer) return buffer.devicon.color end,
                },
                {
                  text = function(buffer) return buffer.unique_prefix end,
                  fg = function(buffer)
                    return buffer.is_focused and cokeline_colors.active_fg or cokeline_colors.prefix
                  end,
                  italic = true,
                },
                {
                  text = function(buffer) return buffer.filename .. " " end,
                  bold = function(buffer) return buffer.is_focused end,
                  underline = function(buffer)
                    return buffer.is_hovered and not buffer.is_focused
                  end,
                },
              },
            })

            -- hlargs
            require("hlargs").setup({
              color = "#b8bb26",
              highlight = {},
              excluded_filetypes = {},
              paint_arg_declarations = true,
              paint_arg_usages = true,
              paint_catch_blocks = { declarations = false, usages = false },
              extras = { named_parameters = false, unused_arguments = true },
              performance = {
                parse_delay = 1, slow_parse_delay = 50,
                max_iterations = 400, max_concurrent_partial_parses = 30,
                debounce = { partial_parse = 3, partial_insert_mode = 100, total_parse = 700, slow_parse = 5000 },
              },
            })
            vim.api.nvim_set_hl(0, "Hlargs",       { fg = "#b8bb26", italic = true })
            vim.api.nvim_set_hl(0, "HlargsUnused", { fg = "#9A9EA5", italic = true })

            -- seeker / telescope transparent picker
            local function set_transparent_picker_highlights()
              local transparent_groups = {
                "TelescopeNormal", "TelescopePromptNormal", "TelescopePromptTitle",
                "TelescopeResultsNormal", "TelescopeResultsTitle",
                "TelescopePreviewNormal", "TelescopePreviewTitle",
              }
              local border_groups = {
                "TelescopeBorder", "TelescopePromptBorder",
                "TelescopeResultsBorder", "TelescopePreviewBorder",
              }
              for _, group in ipairs(transparent_groups) do
                vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
              end
              for _, group in ipairs(border_groups) do
                vim.api.nvim_set_hl(0, group, { fg = "#d97706", ctermfg = 172, bg = "NONE", ctermbg = "NONE" })
              end
            end
            set_transparent_picker_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
              group = vim.api.nvim_create_augroup("TransparentSeekerPicker", { clear = true }),
              callback = set_transparent_picker_highlights,
            })
        '';
    };
}
