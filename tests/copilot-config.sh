#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if rg -n 'copilot-cmp|copilot_cmp|name = "copilot"' modules README.md; then
  echo "legacy Copilot CMP integration remains" >&2
  exit 1
fi

system="$(nix eval --impure --raw --expr builtins.currentSystem)"
out="$(nix build --no-link --print-out-paths ".#packages.${system}.default")"
nvim="$out/bin/nvim"
init="$(mktemp --suffix=.lua)"
trap 'rm -f "$init"' EXIT
"$out/bin/nixvim-print-init" >"$init"

XDG_CONFIG_HOME="$(mktemp -d)" "$nvim" --headless -u NONE \
  "+luafile $init" \
  "+lua assert(vim.fn.executable('node') == 1, 'node missing from PATH'); assert(require('copilot.config').suggestion.auto_trigger == true, 'inline auto-trigger disabled'); assert(require('copilot.config').panel.keymap.open == false, 'native panel mapping must be replaced'); assert(require('copilot.config').nes.enabled == true, 'NES disabled'); assert(vim.fn.maparg('<M-CR>', 'i') ~= '', 'floating panel mapping missing'); assert(vim.g.copilot_nes_debounce == 500, 'NES debounce mismatch'); print('copilot-config-ok')" \
  "+qa"
