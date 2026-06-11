{...}: {
  programs.nixvim = {
    autoGroups.checktime.clear = true;

    autoCmd = [
      {
        event = [
          "FocusGained"
          "TermClose"
          "TermLeave"
        ];
        group = "checktime";
        command = "checktime";
      }
      {
        event = ["TextYankPost"];
        callback.__raw = ''
          function()
            vim.hl.on_yank()
          end
        '';
      }
    ];

    extraConfigLua = ''
      vim.opt.shortmess:append("atWI")
    '';
  };
}
