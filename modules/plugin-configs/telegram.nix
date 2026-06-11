{pkgs, ...}: {
  programs.nixvim = {
    extraConfigLua = ''
      require("telegram").setup({
        tdlib_path = "${pkgs.tdlib}/lib/libtdjson.so",
        panel_position = "right",
      })

      vim.keymap.set("n", "<leader>tg", "<cmd>Tg<CR>", {
        desc = "Toggle Telegram",
        silent = true,
        noremap = true,
      })
    '';
  };
}
