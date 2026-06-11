{...}: {
  programs.nixvim = {
    extraConfigLua = ''
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = "<A-Tab>",
            accept_word = false,
            accept_line = false,
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = false,
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        nes = {
          enabled = false,
        },
      })

      local panel = require("copilot.panel")
      local source_win = nil
      local source_was_insert = false

      local function close_panel()
        panel.close()

        if source_win and vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
          if source_was_insert then
            vim.cmd("startinsert!")
          end
        end
      end

      local function open_floating_panel()
        source_win = vim.api.nvim_get_current_win()
        source_was_insert = vim.fn.mode():match("^[iR]") ~= nil

        panel.open()

        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        if not vim.api.nvim_buf_get_name(buf):match("^copilot://") then
          return
        end

        -- Workaround copilot.lua bug: panel:close() unsets buffer-local keymaps
        -- (<CR> accept, [[, ]], gr) but ensure_bufnr() only re-registers them
        -- when the buffer is recreated. The panel buffer survives closing
        -- (bufhidden=hide), so on every reopen accept silently stops working.
        panel.set_keymap(buf)

        local width = math.max(1, math.min(vim.o.columns - 4, math.floor(vim.o.columns * 0.95)))
        local height = math.max(1, math.min(vim.o.lines - 4, math.floor(vim.o.lines * 0.85)))
        local row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1)
        local col = math.max(0, math.floor((vim.o.columns - width) / 2))

        vim.api.nvim_win_set_config(win, {
          relative = "editor",
          row = row,
          col = col,
          width = width,
          height = height,
          border = "rounded",
          style = "minimal",
        })
        vim.api.nvim_set_option_value(
          "winhighlight",
          "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
          { win = win }
        )

        local opts = { buffer = buf, silent = true, noremap = true }
        vim.keymap.set("n", "j", panel.jump_next, opts)
        vim.keymap.set("n", "k", panel.jump_prev, opts)
        vim.keymap.set("n", "q", close_panel, opts)
        vim.keymap.set("n", "<Esc>", close_panel, opts)
      end

      vim.keymap.set("i", "<A-CR>", open_floating_panel, {
        desc = "Open Copilot variants",
        silent = true,
      })
    '';
  };
}
