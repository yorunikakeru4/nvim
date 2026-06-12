{ pkgs, ... }: {
    programs.nixvim = {
        extraPackages = with pkgs; [
            curl
            jq
        ];

        plugins = {
            ccc = {
                enable = true;
                settings.highlighter = {
                    auto_enable = true;
                    lsp = true;
                };
            };

            image = {
                enable = true;
                settings = {
                    backend = "kitty";
                    kitty_method = "normal";
                    integrations = {
                        markdown = {
                            enabled = true;
                            clear_in_insert_mode = true;
                            download_remote_images = true;
                            only_render_image_at_cursor = true;
                            filetypes = [
                                "markdown"
                                "vimwiki"
                            ];
                        };
                        html.enabled = false;
                        css.enabled = false;
                    };
                    max_width = null;
                    max_height = null;
                    max_width_window_percentage = null;
                    max_height_window_percentage = 50;
                    window_overlap_clear_enabled = true;
                    editor_only_render_when_focused = true;
                    tmux_show_only_in_active_window = true;
                    hijack_file_patterns = [
                        "*.png"
                        "*.jpg"
                        "*.jpeg"
                        "*.gif"
                        "*.webp"
                        "*.avif"
                    ];
                };
            };

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
            local comp = require("profile.components")
            local win_width = vim.o.columns
            require("profile").setup({
              avatar_path = "${../../pictures/kim.png}",
              avatar_opts = {
                avatar_width = 20,
                avatar_height = 20,
                avatar_x = math.floor((win_width - 20) / 2),
                avatar_y = 7,
                force_blank = true,
              },

              user = "yorunikakeru4",
              git_contributions = {
                start_week = 1,
                end_week = 53,
                empty_char = " ",
                full_char = { "", "󰧞", "", "", "" },
                fake_contributions = nil,
                cache_path = "/tmp/profile.nvim/",
                cache_duration = 24 * 60 * 60,
                non_official_api_cmd = [[ curl -s "https://github-contributions-api.jogruber.de/v4/%s?y=$(date -d "1 year ago" +%%Y)&y=$(date +%%Y)" \
                  | jq --arg start $(date -d "1 year ago" +%%Y-%%m-%%d) --arg end $(date +%%Y-%%m-%%d) \
                  '.contributions | [ .[] | select((.date >= $start) and (.date <= $end)) ] | sort_by(.date) | (.[0].date | strptime("%%Y-%%m-%%d") | strftime("%%w") | tonumber) as $wd | map(.count) | ([range(0, $wd) ] | map(0)) + . | . as $array | reduce range(0; length; 7) as $i ({}; . + {($i/7+1 | tostring): $array[$i:$i+7] })' ]],
              },

              hide = {
                statusline = true,
                tabline = true,
              },

              disable_keys = { "h", "j", "k", "<Left>", "<Right>", "<Up>", "<Down>", "<C-f>" },
              cursor_pos = { 0, 0 },

              format = function()
                comp:avatar()
                comp:text_component_render({
                  comp:text_component("git@github.com:yorunikakeru4/nvim", "center", "ProfileRed"),
                  comp:text_component("──── By yorunikakeru4", "right", "ProfileBlue"),
                })
                comp:separator_render()

                comp:card_component_render({
                  type = "table",
                  content = function()
                    return {
                      {
                        title = "yorunikakeru4/yorunikakeru4",
                        description = [[GitHub profile]],
                      },
                    }
                  end,
                  hl = {
                    border = "ProfileYellow",
                    text = "ProfileYellow",
                  },
                })
                comp:separator_render()

                comp:git_contributions_render("ProfileGreen")
              end,
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
