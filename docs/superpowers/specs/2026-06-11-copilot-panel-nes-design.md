# Copilot Panel and Next Edit Suggestions Design

## Goal

Modernize GitHub Copilot integration while preserving fast inline completion and
multi-variant selection. Replace the current bottom split panel with a centered
floating panel styled like the existing Telescope UI. Add experimental Next Edit
Suggestions (NES) without overlapping existing completion keymaps.

## Current Problems

- `copilot.lua` is version 2.0.4 while upstream version 3 is current.
- `copilot-cmp` is an old completion adapter with a local compatibility patch.
- Inline suggestions, the Copilot panel, and `copilot-cmp` are enabled together,
  although `copilot-cmp` recommends disabling the first two.
- After opening the panel once, selecting and accepting later variants is
  unreliable.
- The default bottom split does not match the existing centered Telescope UI.

The first implementation hypothesis is that stale plugin versions and competing
Copilot consumers cause the panel state failure. Verification must reproduce the
failure before changes, then exercise repeated panel cycles after removing
`copilot-cmp` and updating `copilot.lua`.

## Selected Approach

Use the native `copilot.lua` panel rather than a custom Telescope adapter. Style
the panel as a centered floating window with the same transparent background,
orange border, and approximate dimensions as Telescope.

This avoids depending on private Copilot completion APIs. The panel behaves like
a picker but does not provide fuzzy filtering.

## Components

### Copilot Core

- Update `copilot.lua` to a version compatible with Neovim 0.11 and Node.js 22.
- Add Node.js 22 to the runtime packages.
- Remove `copilot-cmp`, its compatibility patch, and the `copilot` source from
  `nvim-cmp`.
- Keep standard LSP, snippet, path, buffer, and dotenv completion unchanged.

### Inline Suggestions

- Enable automatic inline ghost text.
- Hide inline suggestions while the `nvim-cmp` menu is visible.
- Use `<M-l>` to accept the current suggestion.
- Use `<M-]>` and `<M-[>` for next and previous suggestions.
- Preserve an explicit dismiss mapping.

### Variant Panel

- `<M-CR>` opens the native Copilot panel.
- The panel appears in a centered floating window.
- The window uses Telescope-compatible transparent highlights and orange border.
- `j`/`k` and `]]`/`[[` move between variants.
- `<CR>` accepts the selected variant, closes the panel, restores the source
  window, and enters Insert mode.
- `q` and `<Esc>` close the panel without changing the source buffer.
- `gr` refreshes variants.
- Opening, selecting, accepting, and reopening must work repeatedly in the same
  Neovim process.

### Next Edit Suggestions

- Add `copilot-lsp` as the optional NES dependency.
- Enable NES with conservative debounce.
- Use `<leader>cn` in Normal mode to accept the NES and move to its end.
- Use `<leader>cx` in Normal mode to dismiss the NES.
- Keep NES experimental and independent: failure or absence of an NES must not
  affect inline suggestions or the panel.

## Failure Handling

- If Copilot is unauthenticated or unavailable, keep the source buffer unchanged
  and display a concise notification.
- If no panel variants arrive, leave the panel usable for `gr` refresh or clean
  close.
- If NES is unavailable, normal editing and regular Copilot suggestions continue.
- The existing Copilot restart mapping remains, adjusted only if upstream command
  semantics require it.

## Verification

- Build the Nixvim package on `x86_64-linux`.
- Start Neovim headlessly and confirm Copilot, panel, and NES modules load.
- Confirm `copilot-cmp` is absent from runtime and generated configuration.
- Manually test two or more consecutive cycles:
  `<M-CR>` -> choose variant -> `<CR>` -> edit -> `<M-CR>` -> choose variant ->
  `<CR>`.
- Confirm accepted variants return to Insert mode.
- Confirm `q` and `<Esc>` make no source-buffer changes.
- Confirm inline suggestion visibility, acceptance, cycling, and interaction with
  the `nvim-cmp` menu.
- Confirm NES mappings do not shadow existing mappings.

## Out of Scope

- Fuzzy searching Copilot variants.
- A custom Telescope extension or private Copilot API adapter.
- Replacing `nvim-cmp` with `blink.cmp`.
- Adding Copilot Chat, Avante, or another conversational AI interface.
