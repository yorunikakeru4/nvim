{...}: {
  programs.nixvim.extraConfigLua = ''
    local debounce = require("keystroke.debounce")
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
    local play_sound = debounce.debounce_trailing(function(path)
      vim.system({ "pw-play", path })
    end, 50, false)

    require("keystroke").setup({
      auto_start = true,
      handlers = {
        i = {
          sound = {
            enable = true,
            callback = function(key)
              play_sound(sounds[key] or default_sound)
            end,
          },
        },
        ["*"] = {},
      },
    })
  '';
}
