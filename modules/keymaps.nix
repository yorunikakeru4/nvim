{...}: {
  programs.nixvim.extraConfigLua = ''
    local nore_silent = { noremap = true, silent = true }

    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, nore_silent)
    end

    local function buf_map(bufnr, mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", nore_silent, { buffer = bufnr }))
    end

    local function get_project_root() return vim.fn.getcwd() end

    local function has_file_in_project(filenames)
      local cwd = get_project_root()
      for _, fname in ipairs(filenames) do
        if vim.fn.filereadable(cwd .. "/" .. fname) == 1 then return true end
      end
      return false
    end

    local function run_in_toggleterm(cmd_template)
      local file        = vim.fn.expand("%")
      local file_noext  = vim.fn.expand("%:r")
      local file_abs    = vim.fn.expand("%:p")
      local file_dir    = vim.fn.expand("%:p:h")
      local cmd = cmd_template
        :gsub("%%:p:h", file_dir):gsub("%%:p", file_abs)
        :gsub("%%:r", file_noext):gsub("%%", file)
      local root_dir = get_project_root()
      local full_cmd = string.format("cd '%s' && %s", root_dir, cmd)
      require("toggleterm").exec(full_cmd)
    end

    local function get_haskell_tool()
      if has_file_in_project({ "stack.yaml" }) then return "stack"
      elseif has_file_in_project({ "cabal.project" }) or
             #vim.fn.glob(get_project_root() .. "/*.cabal", false, true) > 0 then
        return "cabal"
      end
      return nil
    end

    local function has_nix_flake()
      return has_file_in_project({ "flake.nix" })
    end

    local run_cmds = {
      python = "python3 %",
      javascript = "node %",
      php = "php %",
      go = "go run %",
      cpp = function()
        if has_file_in_project({ "CMakeLists.txt" }) then
          run_in_toggleterm("cmake --build build && ./build/$(basename %:p:h)")
        else
          run_in_toggleterm("g++ -std=c++23 % -o %:r && ./%:r")
        end
      end,
      c = function()
        if has_file_in_project({ "CMakeLists.txt" }) then
          run_in_toggleterm("cmake --build build")
        else
          run_in_toggleterm("gcc % -o %:r && ./%:r")
        end
      end,
      rust = "cargo run --release",
      haskell = function()
        local tool = get_haskell_tool()
        if tool == "stack" then run_in_toggleterm("stack run")
        elseif tool == "cabal" then run_in_toggleterm("cabal run")
        else run_in_toggleterm("runghc %") end
      end,
      elixir = "elixir %",
    }

    local test_cmds = {
      python = { cmd = "pytest",       check = { "pytest.ini", "tests" } },
      javascript = { cmd = "npm test", check = { "package.json" } },
      go = { cmd = "go test ./...",    check = { "go.mod" } },
      php = { cmd = "phpunit",         check = { "phpunit.xml", "tests" } },
      rust = { cmd = "cargo test",     check = { "Cargo.toml" } },
      elixir = { cmd = "mix test",     check = { "mix.exs" } },
    }

    local build_cmds = {
      { check = { "CMakeLists.txt" }, cmd = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build" },
      { check = { "Makefile" },       cmd = "make" },
      { check = { "Cargo.toml" },     cmd = "cargo build" },
      { check = { "stack.yaml" },     cmd = "stack build" },
      { check = { "cabal.project" },  cmd = "cabal build" },
      { check = { "package.json" },   cmd = "npm run build" },
      { check = { "composer.json" },  cmd = "composer install" },
    }

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        local ft = vim.bo.filetype
        local bufnr = vim.api.nvim_get_current_buf()
        pcall(function()
          vim.api.nvim_buf_del_keymap(bufnr, "n", "<leader>E")
          vim.api.nvim_buf_del_keymap(bufnr, "n", "<leader>T")
          vim.api.nvim_buf_del_keymap(bufnr, "n", "<leader>B")
          vim.api.nvim_buf_del_keymap(bufnr, "n", "<leader>I")
        end)
        if has_nix_flake() then
          buf_map(bufnr, "n", "<leader>E", function() run_in_toggleterm("nix run") end)
          buf_map(bufnr, "n", "<leader>B", function() run_in_toggleterm("nix build") end)
          if ft == "haskell" then
            local tool = get_haskell_tool()
            if tool then
              buf_map(bufnr, "n", "<leader>T", function()
                run_in_toggleterm(tool == "stack" and "stack test" or "cabal test")
              end)
              buf_map(bufnr, "n", "<leader>I", function()
                run_in_toggleterm(tool == "stack" and "stack repl" or "cabal repl")
              end)
            end
          else
            local test_cmd = test_cmds[ft]
            if test_cmd and has_file_in_project(test_cmd.check) then
              buf_map(bufnr, "n", "<leader>T", function() run_in_toggleterm(test_cmd.cmd) end)
            end
          end
        else
          local run_cmd = run_cmds[ft]
          if run_cmd then
            buf_map(bufnr, "n", "<leader>E", function()
              if type(run_cmd) == "function" then run_cmd()
              else run_in_toggleterm(run_cmd) end
            end)
          end
          if ft == "haskell" then
            local tool = get_haskell_tool()
            if tool then
              buf_map(bufnr, "n", "<leader>T", function()
                run_in_toggleterm(tool == "stack" and "stack test" or "cabal test")
              end)
              buf_map(bufnr, "n", "<leader>I", function()
                run_in_toggleterm(tool == "stack" and "stack repl" or "cabal repl")
              end)
            end
          else
            local test_cmd = test_cmds[ft]
            if test_cmd and has_file_in_project(test_cmd.check) then
              buf_map(bufnr, "n", "<leader>T", function() run_in_toggleterm(test_cmd.cmd) end)
            end
          end
          for _, build in ipairs(build_cmds) do
            if has_file_in_project(build.check) then
              buf_map(bufnr, "n", "<leader>B", function() run_in_toggleterm(build.cmd) end)
              break
            end
          end
        end
        if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then
          buf_map(bufnr, "n", "<leader>rh", function() vim.cmd("ClangdSwitchSourceHeader") end)
        end
      end,
    })

    -- Motion
    map("n", "q", "%") map("v", "q", "%")
    map("n", "L", "$") map("v", "L", "$")
    map("n", "H", "^") map("v", "H", "^")

    -- File operations
    map("n", "<leader>w",   ":w<CR>")
    map("n", "<leader>W",   ":wa<CR>")
    map("n", "<leader>q",   ":q<CR>")
    map("n", "<leader><Esc>", ":wq<CR>")

    -- UI toggles
    map("n", "<leader>e", ":NvimTreeToggle<CR>")
    map("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
    map("n", "<leader>o", "<cmd>Outline<CR>")
    map("n", "<leader>l", ":Oil<CR>")

    -- Replace
    map("n", "<leader>v", ":%s/")
    map("v", "<leader>v", ":s/")

    -- LSP
    map("n", "<leader>a", function() vim.cmd("LspRestart") vim.cmd("echo 'LSP restarted'") end)

    -- Line movement
    map("n", "<A-k>", ":m .-2<CR>==")
    map("n", "<A-j>", ":m .+1<CR>==")
    map("n", "<A-d>", "yyp")
    map("x", "<A-d>", "y`>o<Esc>pgv")
    map("v", "<A-k>", ":m '<-2<CR>gv=gv")
    map("v", "<A-j>", ":m '>+1<CR>gv=gv")

    map("v", "<A-l>", ">gv")
    map("v", "<A-h>", "<gv")
    map("n", "<A-l>", ">>")
    map("n", "<A-h>", "<<")
    -- Git
    map("n", "<leader>gs", "<cmd>Gitsigns diffthis<CR>")
    map("n", "<leader>gh", "<cmd>GV<CR>")
    map("n", "<leader>gg", "<cmd>LazyGit<CR>")

    -- Find
    local tb = require("telescope.builtin")
    local layout = {
      layout_strategy = "flex",
      layout_config = {
        width = 0.95, height = 0.9,
        horizontal = { prompt_position = "top", preview_width = 0.58, preview_cutoff = 1 },
        vertical   = { prompt_position = "top", preview_height = 0.55, preview_cutoff = 1 },
        flex = { flip_columns = 120 },
      },
      sorting_strategy = "ascending",
      dynamic_preview_title = true,
      path_display = { "smart" },
    }

    map("v", "fg", function()
      vim.cmd('normal! "ay')
      local lines = vim.fn.getreg("a", 1, 1)
      local text = table.concat(lines, " ")
      tb.live_grep(vim.tbl_extend("force", layout, { default_text = text }))
    end)
    map("n", "fd", vim.lsp.buf.definition)
    map("n", "ff", function() tb.find_files(layout) end)
    map("n", "fg", function() tb.live_grep(layout) end)
    map("n", "fb", "<cmd>Telescope buffers<CR>")
    map("n", "fh", "<cmd>Telescope help_tags<CR>")
    map("n", "fr", "<cmd>Telescope oldfiles<CR>")

    -- Wrap with function (visual)
    map("v", "nf", function()
      vim.cmd('normal! "ay')
      local text = vim.fn.getreg("a")
      local func_name = vim.fn.input("Wrap with: ")
      if func_name == "" then return end
      local result
      if func_name:match("%(%s*%)$") then
        result = func_name:gsub("%(%s*%)$", "(" .. text .. ")")
      else
        result = func_name .. " " .. text
      end
      vim.fn.setreg("a", result)
      vim.cmd('normal! gv"ap')
    end)

    -- LSP actions
    map("n", "nr", ":Lspsaga rename<CR>")
    map("n", "nh", vim.lsp.buf.hover)
    map("n", "no", ":Lspsaga incoming_calls <CR>")
    map("n", "nq", ":Lspsaga outgoing_calls <CR>")
    map({ "n", "v" }, "nc", ":Lspsaga code_action<CR>")
    map("n", "nd", ":Lspsaga goto_definition<CR>")
    map("n", "na", function()
      local is_rust = vim.bo.filetype == "rust"
      local is_haskell = vim.bo.filetype == "haskell"
      vim.lsp.buf.code_action({
        filter = function(action)
          if action.title:match("Fill") or action.kind == "refactor.rewrite.fillStruct" then return true end
          if is_rust and action.title:match("Implement missing members") then return true end
          if is_rust and action.title:match("Insert explicit type") then return true end
          if is_rust and action.title:match("Fill match arms") then return true end
          if is_haskell and action.title:match("add signature") then return true end
          return false
        end,
        apply = true,
      })
    end)
    map("n", "ne", function()
      local is_haskell = vim.bo.filetype == "haskell"
      vim.lsp.buf.code_action({
        filter = function(action)
          if is_haskell and action.title:match("Export") then return true end
          return false
        end,
        apply = true,
      })
    end)
    map("n", "ng", ":lua require('neogen').generate()<CR>")

    -- Smart ci
    local function smart_ci()
      local pos = vim.api.nvim_win_get_cursor(0)
      local _, col = pos[1], pos[2]
      local line = vim.api.nvim_get_current_line()
      local len = #line
      if len == 0 then return end
      local idx = col + 1
      local function char_at(i)
        if i < 1 or i > len then return nil end
        return line:sub(i, i)
      end
      local c = char_at(idx)
      local prev = char_at(idx - 1)
      local function inside_quotes(quote)
        local left  = line:sub(1, idx):match(".*()" .. vim.pesc(quote))
        local right = line:sub(idx):match(vim.pesc(quote) .. ".*()")
        return left ~= nil and right ~= nil
      end
      if c == '"' or c == "'" then vim.cmd("normal! ci" .. c) return
      elseif prev == '"' or prev == "'" then vim.cmd("normal! ci" .. prev) return
      elseif inside_quotes('"') then vim.cmd('normal! ci"') return
      elseif inside_quotes("'") then vim.cmd("normal! ci'") return
      end
      local bracket_map = {
        ["("]="(", [")"]="(", ["["]="[", ["]"]="[", ["{"]= "{", ["}"]="{",
      }
      local bracket = bracket_map[c] or bracket_map[prev]
      if bracket then vim.cmd("normal! ci" .. bracket) return end
      vim.cmd("normal! ciw")
    end
    map("n", "ni", smart_ci)
    map("n", "nw", ":Lspsaga finder <CR>")

    -- Add $ to word start
    local function add_dollar()
      local _, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local pos = col + 1
      if not line:sub(pos, pos):match("%w") then return end
      local start = pos
      while start > 1 and line:sub(start - 1, start - 1):match("%w") do start = start - 1 end
      line = line:sub(1, start - 1) .. "$" .. line:sub(start)
      vim.api.nvim_set_current_line(line)
    end
    map("n", "ns", add_dollar)
    map("v", "nt", ":GoTagAdd ")

    -- Diagnostics
    map("n", "zj", "<cmd>Telescope diagnostics<CR>")
    map("n", "zk", vim.diagnostic.open_float)
    map("n", "zh", ":Lspsaga diagnostic_jump_prev <CR>")
    map("n", "zl", ":Lspsaga diagnostic_jump_next <CR>")

    -- Select all
    map("n", "<leader>ac", 'ggVG"+y')
    map("n", "<leader>aa", "ggVG")
    map("n", "<leader>ad", "ggdG")

    -- Buffer navigation
    map("n", "<Tab>",   "<cmd>bnext<CR>")
    map("n", "<C-Tab>", "<cmd>bprevious<CR>")

    -- Marks
    map("n", "Mc", "m")
    map("n", "Md", ":delmarks ")
    map("n", "MC", "mA")
    map("n", "MM", "`")
    map("n", "MD", ":delmarks a-zA-Z0-9<CR>")

    -- Insert navigation
    map("i", "<C-h>", "<Left>")
    map("i", "<C-j>", "<Down>")
    map("i", "<C-k>", "<Up>")
    map("i", "<C-l>", "<Right>")

    -- Buffer tabs
    map("n", "tc", "<cmd>bdelete<CR>")
    map("n", "to", function()
      local current = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.bo[buf].buflisted then
          pcall(vim.api.nvim_buf_delete, buf, {})
        end
      end
    end)

    -- Search
    map("n", ";", "n")
    map("n", "'", "N")

    -- Splits
    map("n", "sh", ":split<CR>")
    map("n", "sv", ":vsplit<CR>")
    map("n", "sc", ":close<CR>")
    map("n", "so", ":only<CR>")
    map("n", "sn", "<C-w>w")
    map("n", "sp", ":resize +5<CR>")
    map("n", "sm", ":resize -5<CR>")
    map("n", "<C-Left>",  "<C-w>h")
    map("n", "<C-Down>",  "<C-w>j")
    map("n", "<C-Up>",    "<C-w>k")
    map("n", "<C-Right>", "<C-w>l")

    -- Highlight
    map("n", "pd", ":nohlsearch<CR>")
    map("n", "pe", ":set hlsearch<CR>*N")
    map("n", "pt", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local hints_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      local diag_enabled  = vim.diagnostic.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not hints_enabled, { bufnr = bufnr })
      vim.diagnostic.enable(not diag_enabled, { bufnr = bufnr })
    end)

    -- Terminal
    map("n", "tf", ":ToggleTerm direction=float size=20<CR>")
    map("n", "th", ":ToggleTerm direction=horizontal size=20<CR>")
    map("n", "tt", ":tab term <CR>")
    map("t", "<Esc>", "<C-\\><C-n>")

    -- Disable arrow keys
    vim.keymap.set("",  "<up>",   "<nop>", { noremap = true })
    vim.keymap.set("",  "<down>", "<nop>", { noremap = true })
    vim.keymap.set("i", "<up>",   "<nop>", { noremap = true })
    vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
  '';
}
