# Keystroke Typewriter Sound Design

## Goal

Add `jerrywang1981/keystroke.nvim` to the Nixvim configuration. Enable
typewriter sounds automatically for keys entered in insert mode.

## Packaging

Add `keystroke-nvim` as a non-flake input in
`modules/nvim-plugins/flake.nix`. Build and export it with the existing
`mk` helper, then add `custom.keystroke-nvim` to
`programs.nixvim.extraPlugins`.

Do not add an audio player or other runtime package. `mpg123` must be
installed outside this flake and available through `PATH`. The plugin checks
for `mpg123` before `aplay`, so it will select the MP3-capable player.

## Configuration

Create a focused plugin configuration module and import it from
`modules/plugin-configs/default.nix`.

Call `require("keystroke").setup` with:

- `auto_start = true`
- one enabled, named `sound` handler for insert mode
- `require("keystroke.sound").play_sound` as callback
- `style = "typewriter"`
- no handlers for other modes

Keep upstream commands available, including `:KeyStrokeEnable`,
`:KeyStrokeDisable`, and `:KeyStrokeToggle`.

## Failure Behavior

Plugin loading and setup remain deterministic through the flake. Sound
playback depends on `mpg123` being present in the runtime `PATH` and a working
audio device. No fallback package is installed by this configuration. Using
the plugin's later `aplay` fallback is unsupported because upstream passes it
MP3 files that ALSA `aplay` cannot decode.

## Verification

Update the nested and root lock files as required by the path input. Format
the Nix files. Run the flake checks and a headless Neovim startup that loads
the generated configuration. Confirm the plugin package is present and its
setup uses automatic insert-mode typewriter sound.
