# Copilot CMP Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Copilot inline ghost text with Copilot completion entries in `nvim-cmp`.

**Architecture:** Package `zbirenbaum/copilot-cmp` through the existing custom plugin flake. Keep `copilot.lua` as the client, disable its inline suggestion UI, and register the `copilot` source in the existing CMP setup.

**Tech Stack:** Nix flakes, Nixvim, Lua, `copilot.lua`, `copilot-cmp`, `nvim-cmp`

---

### Task 1: Package copilot-cmp

**Files:**
- Modify: `modules/nvim-plugins/flake.nix`
- Modify: `modules/nvim-plugins/flake.lock`
- Modify: `flake.lock`
- Modify: `modules/plugins.nix`

- [ ] **Step 1: Verify the package is absent**

Run:

```bash
rg -n "copilot-cmp" modules/nvim-plugins/flake.nix modules/plugins.nix
```

Expected: no matches.

- [ ] **Step 2: Add the flake input and package**

Add:

```nix
copilot-cmp = {
  url = "github:zbirenbaum/copilot-cmp";
  flake = false;
};
```

and:

```nix
copilot-cmp = mk "copilot-cmp" inputs.copilot-cmp;
```

- [ ] **Step 3: Install the custom plugin**

Add `custom.copilot-cmp` beside the other custom plugins in
`modules/plugins.nix`.

- [ ] **Step 4: Update locks**

Run:

```bash
nix flake lock --update-input nvim-plugins
```

Expected: root and nested lock files contain `copilot-cmp`.

### Task 2: Route Copilot suggestions through CMP

**Files:**
- Modify: `modules/plugin-configs/copilot.nix`
- Modify: `modules/completion.nix`

- [ ] **Step 1: Verify current behavior fails the target assertions**

Run:

```bash
rg -n 'suggestion =|enabled = true|name = "copilot"|copilot_cmp' \
  modules/plugin-configs/copilot.nix modules/completion.nix
```

Expected: inline suggestions are enabled and no CMP Copilot source exists.

- [ ] **Step 2: Disable inline suggestions and initialize copilot-cmp**

Set:

```lua
suggestion = {
  enabled = false,
},
```

After `copilot.setup`, add:

```lua
require("copilot_cmp").setup()
```

Keep panel and NES settings unchanged.

- [ ] **Step 3: Add Copilot source formatting**

Add `copilot = "[Copilot]"` to the source label table in
`modules/completion.nix`.

- [ ] **Step 4: Add prioritized CMP source**

Add before `nvim_lsp`:

```lua
{ name = "copilot", group_index = 2, priority = 3000 },
```

- [ ] **Step 5: Format and build**

Run:

```bash
nix fmt modules/nvim-plugins/flake.nix modules/plugins.nix \
  modules/plugin-configs/copilot.nix modules/completion.nix
nix build 'path:.#nvim'
```

Expected: both commands exit successfully.

- [ ] **Step 6: Verify runtime modules and configuration**

Run:

```bash
./result/bin/nvim --headless \
  "+lua assert(require('copilot_cmp')); assert(require('cmp').get_config().sources[1].name == 'copilot'); print('copilot-cmp ok')" \
  +qa
```

Expected: `copilot-cmp ok`.

- [ ] **Step 7: Commit**

```bash
git add flake.lock modules/nvim-plugins/flake.nix \
  modules/nvim-plugins/flake.lock modules/plugins.nix \
  modules/plugin-configs/copilot.nix modules/completion.nix
git commit -m "feat: route Copilot suggestions through cmp"
```
