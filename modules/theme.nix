{...}: {
  programs.nixvim = {
    colorschemes.gruvbox-baby = {
      enable = true;
      settings = {
        transparent_mode = true;
        background_color = "soft";
      };
    };

    extraConfigLua = ''
      local theme_group = vim.api.nvim_create_augroup("ThemeOverrides", { clear = true })

      local function apply_theme_overrides()
        local set = vim.api.nvim_set_hl
        set(0, "CursorLineNr",   { fg = "#F7BF2D", bg = "NONE", bold = true })
        set(0, "Normal",         { bg = "NONE", ctermbg = "NONE" })
        set(0, "NormalNC",       { bg = "NONE", ctermbg = "NONE" })
        set(0, "NormalFloat",    { bg = "NONE", ctermbg = "NONE" })
        set(0, "VertSplit",      { bg = "NONE", ctermbg = "NONE" })
        set(0, "StatusLine",     { bg = "NONE", ctermbg = "NONE" })
        set(0, "StatusLineNC",   { bg = "NONE", ctermbg = "NONE" })
        set(0, "LineNr",         { fg = "#7c6f64", bg = "NONE", ctermbg = "NONE" })

        set(0, "NvimTreeNormal",       { bg = "NONE", ctermbg = "NONE" })
        set(0, "NvimTreeNormalNC",     { bg = "NONE", ctermbg = "NONE" })
        set(0, "NvimTreeNormalFloat",  { bg = "NONE", ctermbg = "NONE" })
        set(0, "NvimTreeEndOfBuffer",  { bg = "NONE", ctermbg = "NONE" })
        set(0, "NvimTreeWinSeparator", { bg = "NONE", ctermbg = "NONE" })
        set(0, "NvimTreeFloat",        { bg = "NONE" })
        set(0, "NvimTreeExecFile",     { fg = "#ffa0a0" })
        set(0, "NvimTreeSpecialFile",  { fg = "#ff80ff", underline = true })
        set(0, "NvimTreeSymlink",      { fg = "Yellow", italic = true })
        set(0, "NvimTreeImageFile",    { link = "Title" })

        set(0, "markdownLineStart",    { link = "Normal",  default = true })
        set(0, "markdownH1",           { link = "Title",   default = true })
        set(0, "markdownH2",           { link = "Title",   default = true })
        set(0, "markdownHeadingRule",  { link = "Title",   default = true })
        set(0, "markdownRule",         { link = "Comment", default = true })
        set(0, "markdownCode",         { link = "String",  default = true })
        set(0, "markdownCodeBlock",    { link = "String",  default = true })
        set(0, "markdownIdDeclaration",{ link = "Identifier", default = true })

        set(0, "FloatBorder",           { fg = "#D65D0E", bg = "#3c3836" })

        set(0, "LspInlayHint",          { fg = "#9A9EA5", bg = "NONE", italic = true })
        set(0, "LspInlayHintType",      { fg = "#808080", bg = "NONE", italic = true })
        set(0, "LspInlayHintParameter", { fg = "#808080", bg = "NONE", italic = true })
        set(0, "LspReferenceText",  { bg = "#3E4451" })
        set(0, "LspReferenceRead",  { bg = "#3E4451" })
        set(0, "LspReferenceWrite", { bg = "#3E4451" })

        set(0, "Visual", { blend = 10, bg = "#221f59" })
        set(0, "@lsp.type.namespace.go",            { fg = "#C586C0" })
        set(0, "@lsp.typemod.variable.external.go", { fg = "#A3BE8C" })

        set(0, "FidgetProgress", { fg = "#a9b665" })
        set(0, "FidgetDone",     { fg = "#7daea3" })
        set(0, "FidgetGroup",    { fg = "#de254e" })
        set(0, "FidgetIcon",     { fg = "#a9b665" })
        set(0, "FidgetNormal",   { fg = "#d8a657" })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = theme_group,
        callback = function() vim.schedule(apply_theme_overrides) end,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = theme_group,
        callback = function() vim.schedule(apply_theme_overrides) end,
      })
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function() vim.defer_fn(apply_theme_overrides, 50) end,
      })

      apply_theme_overrides()
    '';
  };
}
