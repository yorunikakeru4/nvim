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
    ];

    extraConfigLua = ''
      vim.opt.shortmess:append("atWI")
    '';
  };
}
