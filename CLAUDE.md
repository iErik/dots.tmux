# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal tmux configuration repository. The primary config is `tmux.conf`, with a shell script (`status`) for the status bar.

## Key Commands

Reload tmux config (within tmux): `prefix + r` (which runs `source-file ~/.config/tmux/tmux.conf`)

## Configuration Structure

- `tmux.conf` — Main tmux configuration. Defines keybindings, terminal settings, and status bar appearance using inline tmux format strings with Nerd Font glyphs.
- `status` — Shell script called by tmux's `status-right`. Uses `sensors` for CPU temp, `bat` for battery, and `date` for clock. Returns a formatted string with tmux color codes.
- `plugins/tpm` — Tmux Plugin Manager (submodule). Currently unused; TPM lines in `tmux.conf` are commented out.

## Key Bindings

- Prefix: `C-a` (remapped from `C-b`)
- Split horizontal: `prefix + |`; vertical: `prefix + -` (both preserve current path)
- Pane navigation: `M-h/j/k/l` and `M-arrow` (no prefix needed)
- Window prev/next: `M-[` / `M-]`
- Copy mode: `M-v` or `M-Tab`; copy mode uses vi keys

## Status Bar

The status bar uses tmux color variables and Nerd Font glyphs. The right side is defined via shell variables (`clock`, `date`, `winname`) composed inline in `tmux.conf`. The `status` script is referenced but currently overridden by the inline variable assignment on the same `status-right` line.

## Conventions

- Windows and panes are 1-indexed (`base-index 1`, `pane-base-index 1`)
- Terminal: `tmux-256color` with truecolor, undercurl, and underscore color overrides
- `escape-time` is 20ms (low, for responsive Esc in editors)
