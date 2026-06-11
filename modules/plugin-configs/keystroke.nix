{...}: {
  programs.nixvim.extraConfigLua = ''
    require("keystroke").setup({
      auto_start = true,
      handlers = {
        i = {
          sound = {
            enable = true,
            callback = require("keystroke.sound").play_sound,
            options = {
              style = "typewriter",
            },
          },
        },
        ["*"] = {},
      },
    })
  '';
}
