{ ... }: {
    programs.nixvim.extraConfigLua = ''
        local cmp = require("cmp")
        local lsp_kind_icons = {
          Function = "󰊕",
          Method = "󰡱",
          Variable = "󰀫",
          Field = "󰀻",
          Class = "󰠱",
          Interface = "󰜰",
          Text = "󰉿",
          Snippet = "󰳗",
          Module = "󰏓",
          Keyword = "󰌋",
          Enum = "󰒻",
          EnumMember = "󰒻",
        }
        local cmp_enabled = true
        vim.keymap.set("n", "<leader>af", function()
          cmp_enabled = not cmp_enabled
          print("cmp: " .. (cmp_enabled and "ON" or "OFF"))
        end, { desc = "Toggle nvim-cmp" })

        local compare = cmp.config.compare
        cmp.setup({
          formatting = {
            fields = { "abbr", "kind", "menu" },
            format = function(entry, vim_item)
              if lsp_kind_icons[vim_item.kind] then
                vim_item.kind = lsp_kind_icons[vim_item.kind] .. " " .. vim_item.kind
              end
              local completion_item = entry:get_completion_item()
              local detail = nil
              if completion_item.labelDetails and completion_item.labelDetails.detail then
                detail = completion_item.labelDetails.detail
              elseif completion_item.detail then
                detail = completion_item.detail
              end
              local source_label = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                path = "[Path]",
              })[entry.source.name] or ""
              if detail and detail ~= "" then
                if #detail > 10 then detail = detail:sub(1, 15) .. "..." end
                vim_item.menu = detail .. " " .. source_label
              else
                vim_item.menu = source_label
              end
              return vim_item
            end,
          },
          view = { entries = { name = "custom", selection_order = "top_down" } },
          preselect = cmp.PreselectMode.None,
          sorting = {
            priority_weight = 1.5,
            comparators = {
              compare.offset, compare.exact, compare.score, compare.recently_used,
              compare.locality, compare.kind, compare.sort_text, compare.length, compare.order,
            },
          },
          performance = {
            debounce = 60, throttle = 30, fetching_timeout = 120,
            filtering_context_budget = 5, confirm_resolve_timeout = 80, max_view_entries = 15,
          },
          completion = {
            autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
          },
          mapping = {
            ["<A-j>"] = cmp.mapping(function(fallback)
              if cmp_enabled and cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else fallback() end
            end, { "i", "s" }),
            ["<A-k>"] = cmp.mapping(function(fallback)
              if cmp_enabled and cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else fallback() end
            end, { "i", "s" }),
            ["<A-Tab>"] = cmp.mapping(function(fallback)
              if cmp_enabled and cmp.visible() then
                cmp.confirm({ select = true })
              else fallback() end
            end, { "i", "s" }),
          },
          window = {
            completion = {
              winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel",
              border = "rounded",
            },
            documentation = {
              winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
              border = "rounded",
            },
          },
          sources = {
            { name = "nvim_lsp", group_index = 2, priority = 2500 },
            { name = "luasnip",  group_index = 2},
            { name = "path",     group_index = 2 },
            { name = "buffer",   group_index = 2 },
            { name = "dotenv",   group_index = 2 },
          },
          enabled = function() return cmp_enabled end,
        })

        -- Gruvbox Baby CMP highlights
        local g = {
          bg0 = "NONE", bg1 = "NONE", bg2 = "NONE",
          fg = "#ddc7a1", fg_dim = "#928374",
          red = "#ea6962", orange = "#e78a4e", yellow = "#d8a657",
          green = "#a9b665", aqua = "#89b482", blue = "#7daea3", purple = "#d3869b",
        }
        vim.api.nvim_set_hl(0, "CmpNormal",    { fg = g.fg,     bg = g.bg0 })
        vim.api.nvim_set_hl(0, "CmpBorder",    { fg = g.blue,   bg = g.bg0 })
        vim.api.nvim_set_hl(0, "CmpDocNormal", { fg = g.fg,     bg = g.bg0 })
        vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = g.aqua,   bg = g.bg0 })
        vim.api.nvim_set_hl(0, "PmenuSel",     { fg = "NONE",   bg = g.yellow, bold = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbr",              { fg = g.fg,     bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",    { fg = g.fg_dim, bg = "NONE", strikethrough = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",         { fg = g.blue,   bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",    { fg = g.orange, bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemMenu",              { fg = g.fg_dim, bg = "NONE", italic = true })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction",      { fg = g.green,  bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod",        { fg = g.green,  bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindConstructor",   { fg = g.green,  bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable",      { fg = g.blue,   bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindField",         { fg = g.blue,   bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindProperty",      { fg = g.blue,   bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindClass",         { fg = g.purple, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindStruct",        { fg = g.purple, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindInterface",     { fg = g.purple, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindModule",        { fg = g.purple, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindEnum",          { fg = g.orange, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindEnumMember",    { fg = g.orange, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = g.orange, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindConstant",      { fg = g.yellow, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindValue",         { fg = g.yellow, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindUnit",          { fg = g.yellow, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword",       { fg = g.red,    bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindOperator",      { fg = g.red,    bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindEvent",         { fg = g.red,    bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet",       { fg = g.aqua,   bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindReference",     { fg = g.aqua,   bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindFile",          { fg = g.fg_dim, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindFolder",        { fg = g.yellow, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindText",          { fg = g.fg_dim, bg = "NONE" })
        vim.api.nvim_set_hl(0, "CmpItemKindColor",         { fg = g.aqua,   bg = "NONE" })
    '';
}
