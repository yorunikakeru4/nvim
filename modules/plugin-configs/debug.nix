{...}: {
  programs.nixvim = {
    plugins = {
      dap.enable = true;
      dap-ui.enable = true;
    };

    extraConfigLua = ''
      -- nvim-dap-virtual-text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- dap-ui auto open/close
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config   = function() dapui.open() end
      dap.listeners.before.launch.dapui_config   = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end

      -- DAP keymaps
      local nore_s = { noremap = true, silent = true }
      vim.keymap.set("n", "<F5>",  dap.continue,          vim.tbl_extend("force", nore_s, { desc = "DAP continue" }))
      vim.keymap.set("n", "<F10>", dap.step_over,         vim.tbl_extend("force", nore_s, { desc = "DAP step over" }))
      vim.keymap.set("n", "<F11>", dap.step_into,         vim.tbl_extend("force", nore_s, { desc = "DAP step into" }))
      vim.keymap.set("n", "<F12>", dap.step_out,          vim.tbl_extend("force", nore_s, { desc = "DAP step out" }))
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", nore_s, { desc = "DAP toggle breakpoint" }))
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, vim.tbl_extend("force", nore_s, { desc = "DAP conditional breakpoint" }))
      vim.keymap.set("n", "<leader>dr", dap.repl.open,    vim.tbl_extend("force", nore_s, { desc = "DAP open REPL" }))
      vim.keymap.set("n", "<leader>dl", dap.run_last,     vim.tbl_extend("force", nore_s, { desc = "DAP run last" }))
      vim.keymap.set("n", "<leader>du", dapui.toggle,     vim.tbl_extend("force", nore_s, { desc = "DAP toggle UI" }))
      vim.keymap.set("n", "<leader>dx", dap.terminate,    vim.tbl_extend("force", nore_s, { desc = "DAP terminate" }))
      vim.keymap.set({ "n", "v" }, "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, vim.tbl_extend("force", nore_s, { desc = "DAP hover" }))
    '';
  };
}
