{...}: {
  programs.nixvim.extraConfigLua = ''
    -- LuaSnip
    local ls = require("luasnip")
    local s  = ls.snippet
    local t  = ls.text_node
    local i  = ls.insert_node
    ls.config.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = { virt_text = { { "●", "GruvboxOrange" } } },
        },
      },
    })
    ls.filetype_extend("php", { "html" })

    ls.add_snippets("go", {
      s("struct", { t("type "), i(1, "MyStruct"), t(" struct {"), t({ "", "\t" }), i(0), t({ "", "}" }) }),
      s("interface", { t("type "), i(1, "MyInterface"), t(" interface {"), t({ "", "\t" }), i(0), t({ "", "}" }) }),
      s("type", { t("type "), i(1, "MyType"), t(" "), i(2, "Type") }),
      s({ trig = "wg%.Go", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, {
        t("wg.Go(func() {"), t({ "", "\t" }), i(0), t({ "", "})" }),
      }),
    })
    ls.add_snippets("elixir", {
      s("start", {
        t("def start(_type, _args) do"), t({ "", "  " }), i(1, "children = []"),
        t({ "", "  opts = [strategy: :one_for_one, name: MyApp.Supervisor]" }),
        t({ "", "  " }), t("  Supervisor.start_link("), i(2, "children, opts"), t(")"),
        t({ "", "end" }), i(0),
      }),
      s("defst", { t("defstruct "), i(1, "row:"), i(2, ' ""') }),
      s({ trig = "pp", snippetType = "autosnippet", wordTrig = true }, { t("|> "), i(0) }),
      s({ trig = ">>", snippetType = "autosnippet", wordTrig = true }, { t("|> "), i(0) }),
    })
    ls.add_snippets("php", {
      s("fn", { t("fn ("), i(1, "$arg"), t(") => "), i(2, "$arg"), t(";") }),
    })
    ls.add_snippets("markdown", {
      s({ trig = "alpha", snippetType = "autosnippet" }, { t("󰀫"), i(0) }),
      s({ trig = "beta",  snippetType = "autosnippet" }, { t("󰂡"), i(0) }),
      s({ trig = "sum",   snippetType = "autosnippet" }, { t("󰒠"), i(0) }),
    })
    require("luasnip.loaders.from_vscode").lazy_load()
  '';
}
