# Copilot CMP Integration

## Goal

Replace Copilot inline ghost-text suggestions with Copilot entries in the existing
`nvim-cmp` completion menu.

## Design

- Add `zbirenbaum/copilot-cmp` as a custom Neovim plugin.
- Keep `copilot.lua` as the Copilot client and authentication layer.
- Disable `copilot.lua` inline suggestions.
- Keep the Copilot panel and its `<A-CR>` mapping unchanged.
- Keep Copilot NES disabled.
- Register and configure `copilot-cmp`.
- Add the `copilot` source to the existing `nvim-cmp` source list with higher
  priority than LSP completions.
- Display Copilot entries with a `[Copilot]` source label.
- Keep `<A-j>`, `<A-k>`, and `<A-Tab>` completion mappings unchanged.

## Data Flow

`copilot.lua` requests suggestions from Copilot. `copilot-cmp` converts those
suggestions into completion items. `nvim-cmp` sorts and displays them alongside
LSP, snippet, path, buffer, and dotenv entries.

## Failure Behavior

If Copilot is unavailable or unauthenticated, the `copilot` source returns no
items. Other completion sources and the Copilot panel continue working.

## Verification

- Nix configuration evaluates and builds.
- `copilot-cmp` loads in the built Neovim package.
- `copilot.lua` inline suggestions remain disabled.
- The `copilot` source is registered in `nvim-cmp`.
- Existing panel and CMP mappings remain present.
