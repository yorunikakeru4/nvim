{...}: {
  programs.nixvim = {
    autoCmd = [
      {
        event = "FileType";
        pattern = "*";
        command = "setlocal formatoptions-=r formatoptions-=o";
      }
      {
        event = [
          "BufReadPost"
          "BufWritePost"
        ];
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      }
    ];

    plugins.todo-comments.settings = {
      signs = true;
      sign_priority = 8;
      highlight.pattern = ".*<(KEYWORDS)\\s*:";
      colors = {
        error = ["DiagnosticError" "ErrorMsg" "#DC2626"];
        warning = ["DiagnosticWarn" "WarningMsg" "#FBBF24"];
        info = ["DiagnosticInfo" "#2563EB"];
        hint = ["DiagnosticHint" "#10B981"];
        default = ["Identifier" "#7C3AED"];
        test = ["Identifier" "#FF00FF"];
      };
      keywords = {
        FIX = {
          icon = "󰁨";
          color = "error";
          alt = ["FIXME" "BUG" "FIXIT" "ISSUE"];
        };
        TODO = {
          icon = "󱢇";
          color = "info";
        };
        WARN = {
          icon = "!!";
          color = "warning";
          alt = ["WARNING" "XXX"];
        };
        NOTE = {
          icon = "";
          color = "info";
          alt = ["INFO"];
        };
        TEST = {
          icon = "⊘ ";
          color = "test";
          alt = ["TESTING" "PASSED" "FAILED"];
        };
      };
    };
  };
}
