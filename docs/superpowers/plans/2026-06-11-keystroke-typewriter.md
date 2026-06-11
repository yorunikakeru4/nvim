# Keystroke Typewriter Sound Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Package `keystroke.nvim` through the existing custom-plugin flake and start insert-mode typewriter sounds automatically without adding an audio player dependency.

**Architecture:** The nested `modules/nvim-plugins` flake owns the upstream source and Vim plugin derivation. The main Nixvim module adds that derivation to `extraPlugins`, while a focused plugin-config module calls upstream `setup`; runtime playback discovers an externally installed `mpg123` through `PATH`.

**Tech Stack:** Nix flakes, Nixvim, Lua, Neovim, `keystroke.nvim`, Bash

---

## File Structure

- Create `tests/keystroke-config.sh`: static packaging checks plus generated Neovim runtime assertions.
- Modify `modules/nvim-plugins/flake.nix`: declare and package `keystroke.nvim`.
- Generated `modules/nvim-plugins/flake.lock`: pin the upstream source.
- Generated `flake.lock`: refresh the root path input after the nested lock changes.
- Modify `modules/plugins.nix`: add the custom plugin to Nixvim.
- Create `modules/plugin-configs/keystroke.nix`: own plugin setup.
- Modify `modules/plugin-configs/default.nix`: import the focused setup module.

### Task 1: Add Failing Regression Check

**Files:**
- Create: `tests/keystroke-config.sh`

- [ ] **Step 1: Write the failing check**

```bash
#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

rg -q 'keystroke-nvim = {' modules/nvim-plugins/flake.nix
rg -q 'keystroke-nvim = mk "keystroke-nvim" inputs.keystroke-nvim;' modules/nvim-plugins/flake.nix
rg -q 'custom.keystroke-nvim' modules/plugins.nix
rg -q './keystroke.nix' modules/plugin-configs/default.nix

system="$(nix eval --impure --raw --expr builtins.currentSystem)"
out="$(nix build --no-link --print-out-paths ".#packages.${system}.default")"
nvim="$out/bin/nvim"

"$nvim" --headless \
  "+lua local c = require('keystroke').config(); assert(c.auto_start == true, 'keystroke auto-start disabled')" \
  "+lua local h = require('keystroke').config().handlers.i.sound; assert(h.enable == true, 'sound handler disabled'); assert(h.options.style == 'typewriter', 'wrong sound style')" \
  "+lua assert(vim.fn.exists(':KeyStrokeToggle') == 2, 'toggle command missing')" \
  "+qa"
```

- [ ] **Step 2: Make the check executable**

Run: `chmod +x tests/keystroke-config.sh`

- [ ] **Step 3: Verify the check fails for the missing feature**

Run: `./tests/keystroke-config.sh`

Expected: non-zero exit at the first missing `keystroke-nvim` assertion.

- [ ] **Step 4: Commit the failing check**

```bash
git add tests/keystroke-config.sh
git commit -m "test: cover keystroke typewriter configuration"
```

### Task 2: Package Keystroke

**Files:**
- Modify: `modules/nvim-plugins/flake.nix`
- Generated: `modules/nvim-plugins/flake.lock`
- Generated: `flake.lock`
- Modify: `modules/plugins.nix`

- [ ] **Step 1: Add the upstream non-flake input**

Add under `inputs` in `modules/nvim-plugins/flake.nix`:

```nix
keystroke-nvim = {
  url = "github:jerrywang1981/keystroke.nvim";
  flake = false;
};
```

- [ ] **Step 2: Export the Vim plugin derivation**

Add under `packages` in `modules/nvim-plugins/flake.nix`:

```nix
keystroke-nvim = mk "keystroke-nvim" inputs.keystroke-nvim;
```

- [ ] **Step 3: Generate lock updates**

Run:

```bash
nix flake lock modules/nvim-plugins
nix flake lock
```

Expected: nested lock gains `keystroke-nvim`; root lock updates the `nvim-plugins` path node metadata without unrelated source upgrades.

- [ ] **Step 4: Add the plugin to Nixvim**

Add to the custom-plugin section of `programs.nixvim.extraPlugins`:

```nix
custom.keystroke-nvim
```

Do not add `mpg123`, `alsa-utils`, `pulseaudio`, or another player package.
`mpg123` remains an external runtime prerequisite.

- [ ] **Step 5: Evaluate the packaged source**

Run:

```bash
nix eval --raw --impure --expr \
  'let f = builtins.getFlake (toString ./modules/nvim-plugins); in f.packages.${builtins.currentSystem}.keystroke-nvim.version'
```

Expected: a non-empty locked revision.

- [ ] **Step 6: Commit packaging**

```bash
git add modules/nvim-plugins/flake.nix modules/nvim-plugins/flake.lock flake.lock modules/plugins.nix
git commit -m "build: package keystroke.nvim"
```

### Task 3: Configure Automatic Typewriter Sound

**Files:**
- Create: `modules/plugin-configs/keystroke.nix`
- Modify: `modules/plugin-configs/default.nix`

- [ ] **Step 1: Create focused setup module**

Create `modules/plugin-configs/keystroke.nix`:

```nix
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
```

- [ ] **Step 2: Import the module**

Add to `modules/plugin-configs/default.nix`:

```nix
./keystroke.nix
```

- [ ] **Step 3: Format changed Nix files**

Run:

```bash
nix fmt modules/nvim-plugins/flake.nix modules/plugins.nix modules/plugin-configs/default.nix modules/plugin-configs/keystroke.nix
```

Expected: formatter exits zero.

- [ ] **Step 4: Run regression check**

Run: `./tests/keystroke-config.sh`

Expected: exit zero; generated Neovim reports automatic startup and `typewriter` style.

- [ ] **Step 5: Commit configuration**

```bash
git add modules/plugin-configs/default.nix modules/plugin-configs/keystroke.nix
git commit -m "feat: enable typewriter keystroke sounds"
```

### Task 4: Full Verification

**Files:**
- Verify all changed files.

- [ ] **Step 1: Check formatting and whitespace**

Run:

```bash
nix fmt -- --check .
git diff --check
```

Expected: both commands exit zero.

- [ ] **Step 2: Run complete flake checks**

Run: `nix flake check`

Expected: exit zero for the current system.

- [ ] **Step 3: Confirm no audio dependency was added**

Run:

```bash
git diff HEAD~3 -- modules/plugins.nix | rg 'alsa-utils|pulseaudio|mpg123|vlc'
```

Expected: exit one because no audio player package appears in the diff.

- [ ] **Step 4: Inspect final scope**

Run:

```bash
git status --short
git log -4 --oneline
```

Expected: clean worktree and three implementation commits after the design commit.
