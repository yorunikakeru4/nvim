{...}: {
  programs.nixvim.extraConfigLua = ''
    local lsp = vim.lsp

    lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
    lsp.set_log_level("off")

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if not client then return end

        if client.server_capabilities.inlayHintProvider then
          lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        if client.name == "sqls" or client.name == "html" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.documentOnTypeFormattingProvider = false
        end

        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group, buffer = bufnr,
            callback = lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group, buffer = bufnr,
            callback = lsp.buf.clear_references,
          })
        end

        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = lsp.codelens.refresh,
          })
        end
      end,
    })
  '';
}
