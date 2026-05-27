{...}: {
  programs.nixvim = {
    opts = {
      sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    };

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
