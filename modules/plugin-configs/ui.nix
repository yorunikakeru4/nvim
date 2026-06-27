{ pkgs, ... }: {
    programs.nixvim = {
        plugins = {
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
            require("match").setup()
            require("render-markdown.state").config.conceal = nil

            -- cokeline
            local cokeline_colors = {
              active_bg = "#2d353b",
              active_fg = "#a7c080",
              inactive_bg = "NONE",
              inactive_fg = "#859289",
              prefix = "#7a8478",
              close = "#e67e80",
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
