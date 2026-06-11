{...}: {
  programs.nixvim.extraConfigLua = ''
    local default_sound = vim.api.nvim_get_runtime_file(
      "lua/keystroke/sound/typewriter/default.ogg",
      false
    )[1]
    local sounds = {
      [string.char(13)] = vim.api.nvim_get_runtime_file(
        "lua/keystroke/sound/typewriter/enter.ogg",
        false
      )[1],
    }

    require("keystroke").setup({
      auto_start = true,
      handlers = {
        i = {
          sound = {
            enable = true,
            callback = function(key)
              vim.system({ "pw-play", sounds[key] or default_sound })
            end,
          },
        },
        ["*"] = {},
      },
    })
  '';
}
