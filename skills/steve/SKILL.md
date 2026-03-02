---
name: steve
description: Use the steve CLI to automate macOS apps via Accessibility APIs. Use when you need to drive Mac UI (apps, windows, menus, elements), run UI smoke tests, or script interactions using steve commands and JSON output.
---

# Steve

## Overview

Use the `steve` CLI to automate macOS applications through the Accessibility API. Prefer steve when you need deterministic, scriptable UI control with JSON responses.

## Quick Start

1. Assume the CLI is installed and available on `PATH`. If not, download it from the GitHub releases page: https://github.com/mikker/steve/releases
2. Ensure Accessibility permissions are granted for the terminal running steve.

```bash
steve apps
```

## Core Tasks

### Target an app or window

Use `--app`, `--bundle`, or `--pid` to select the app, and `--window` to scope to a window title.

Before any click, typing, menu, or key interaction, make the target app frontmost with `steve focus`. Treat this as mandatory, not optional, because background-window interaction can fail even when element lookup succeeds.

Global flags belong after the command name. Use `steve click --pid 123 ...`, not `steve --pid 123 click ...`.

```bash
steve focus --app "System Settings"
steve elements --app "System Settings" --window "Settings"
```

For command-specific help, use:

```bash
steve find --help
steve click --help
```

### Find text reliably

Use `--text` to match visible text via `AXValue`, `AXDescription`, or `AXStaticText` title (case-insensitive substring).

```bash
steve find --text "Dictation Mode" --window "Settings"
```

For SwiftUI sidebars, prefer row-aware discovery before inspecting the whole tree:

```bash
steve outline-rows --window "QuickWhisper"
steve find --text "react" --window "QuickWhisper" --descendants
```

Use `find --text ... --descendants` mainly to discover the live row or cell path. If the output includes a row or cell id, click that id directly instead of assuming `--ancestor-role ... --click` will always succeed.

### Click the right ancestor

After a text match, use `--ancestor-role` and `--click` to press a nearby container row/cell/button.

```bash
steve find --text "Dictation Mode" --window "Settings" --ancestor-role AXRow --click
```

### Common interactions

```bash
steve click --title "OK"
steve type "hello world"
steve key cmd+shift+p
steve menu "File" "New"
```

## Reliability Tips

- Prefer `--window` and `--text` over raw coordinates.
- Always call `steve focus` on the target app before interacting with its UI.
- Use `outline-rows` for list/sidebar UIs when possible; it is more reliable than scanning a deep AX tree manually.
- If multiple outlines may exist in one window, confirm the returned row labels match the intended sidebar before clicking.
- If `elements` looks truncated, increase `--depth` because complex SwiftUI hierarchies often need more than the default traversal depth.
- Avoid relying on a previously captured `ax://...` id after the UI changes. If a click fails with `Element not found`, re-query the current UI state and get a fresh id.
- After a click, verify the expected state change by checking something observable such as the window title, selected row state, or a known element in the destination view.
- Use this fallback order for UI interaction: `focus` -> `outline-rows` or `find --descendants` -> click live row/cell id -> re-query if the id fails -> coordinate click only as a last resort.
- Use `wait` for UI state changes before clicking:

```bash
steve wait --title "Results" --timeout 5
```
