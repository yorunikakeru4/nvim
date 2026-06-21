{ ... }: {
    programs.nixvim.extraConfigLua = ''
        -- lualine (custom line)
        local colors = {
          bg = "NONE", fg = "#ebdbb2", yellow = "#fabd2f", cyan = "#8ec07c",
          darkblue = "#458588", green = "#b8bb26", orange = "#fe8019",
          violet = "#d3869b", magenta = "#b16286", blue = "#83a598", red = "#fb4934",
        }
        local conditions = {
          buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
          hide_in_width    = function() return vim.fn.winwidth(0) > 80 end,
        }
        local mode_names = {
          n="NORMAL", no="NORMAL", nov="NORMAL", noV="NORMAL",
          niI="NORMAL", niR="NORMAL", niV="NORMAL", nt="NORMAL",
          v="VISUAL", vs="VISUAL", V="V-LINE", Vs="V-LINE",
          ["\22"]="V-BLOCK", ["\22s"]="V-BLOCK",
          s="SELECT", S="S-LINE", ["\19"]="S-BLOCK",
          i="INSERT", ic="INSERT", ix="INSERT",
          R="REPLACE", Rc="REPLACE", Rx="REPLACE", Rv="V-REPLACE",
          c="COMMAND", cv="COMMAND", r="CONFIRM", rm="MORE",
          ["r?"]="CONFIRM", ["!"]="SHELL", t="TERMINAL",
        }
        local mode_colors = {
          n="green", no="green", nov="green", noV="green",
          niI="green", niR="green", niV="green", nt="green",
          v="orange", vs="orange", V="orange", Vs="orange",
          ["\22"]="red", ["\22s"]="red",
          s="orange", S="orange", ["\19"]="orange",
          i="blue", ic="blue", ix="blue",
          R="violet", Rc="violet", Rx="violet", Rv="violet",
          ["r?"]="cyan", ["!"]="red", t="red",
        }
        local transparent = { fg = colors.fg, bg = colors.bg }
        local lualine_config = {
          options = {
            component_separators = "",
            section_separators   = "",
            theme = {
              normal   = { a = transparent, b = transparent, c = transparent },
              insert   = { a = transparent, b = transparent, c = transparent },
              visual   = { a = transparent, b = transparent, c = transparent },
              replace  = { a = transparent, b = transparent, c = transparent },
              command  = { a = transparent, b = transparent, c = transparent },
              inactive = { a = transparent, b = transparent, c = transparent },
            },
          },
          sections = { lualine_a={}, lualine_b={}, lualine_y={}, lualine_z={}, lualine_c={}, lualine_x={} },
          inactive_sections = { lualine_a={}, lualine_b={}, lualine_y={}, lualine_z={}, lualine_c={}, lualine_x={} },
        }
        local function ins_left(c)   table.insert(lualine_config.sections.lualine_b, c) end
        local function ins_center(c) table.insert(lualine_config.sections.lualine_c, c) end
        local function ins_right(c)  table.insert(lualine_config.sections.lualine_x, c) end

        ins_left({ function() return "▊" end, color = { fg = colors.orange }, padding = { left=0, right=1 } })
        ins_left({
          function() return "󱄅" end,
          color = function()
            local mode_color = {
              n="green", i="blue", v="orange", [""]="orange", V="orange", c="magenta",
              no="green", s="orange", S="orange", [""]="orange", ic="yellow",
              R="violet", Rv="violet", cv="red", ce="red", r="cyan", rm="cyan",
              ["r?"]="cyan", ["!"]="red", t="red",
            }
            return { fg = colors[mode_color[vim.fn.mode()]] or colors.fg }
          end,
          padding = { right=1 },
        })
        ins_left({
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error=" ", warn=" ", info=" " },
          diagnostics_color = {
            error = { fg = colors.red }, warn = { fg = colors.yellow }, info = { fg = colors.blue },
          },
        })
        ins_left({
          function()
            local buf_ft  = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if vim.tbl_isempty(clients) then return " No LSP" end
            local names = {}
            for _, client in ipairs(clients) do
              if client.config.filetypes and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
                table.insert(names, client.name)
              end
            end
            return #names > 0 and (" " .. table.concat(names, ",")) or " No LSP"
          end,
          color = { fg = colors.cyan, gui = "bold" },
          padding = { right=1 },
        })
        ins_center({
          function() return mode_names[vim.fn.mode()] or vim.fn.mode():upper() end,
          color = function()
            return { fg = colors[mode_colors[vim.fn.mode()]] or colors.fg, gui = "bold" }
          end,
          padding = { left = 2, right = 2 },
        })

        ins_right({ "branch", icon = "", color = { fg = colors.violet, gui = "bold" } })
        ins_right({
          "diff",
          symbols = { added="+", modified="~", removed="-" },
          diff_color = { added={fg=colors.green}, modified={fg=colors.orange}, removed={fg=colors.red} },
          cond = conditions.hide_in_width,
        })
        ins_right({ function() return "▊" end, color = { fg = colors.orange }, padding = { left=1 } })
        require("lualine").setup(lualine_config)
        vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    '';
}
