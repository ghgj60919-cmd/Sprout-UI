# SproutUI

An early, dependency-free Luau module for simple Roblox client interfaces.
Version: 0.1.0 (prototype). License: MIT.

## Purpose
Help beginner Roblox developers build small settings panels without repeating
instance creation and event cleanup code. No remote scripts, tracking, external
assets, or runtime dependencies are included.

## Included
- Centered window that scales down for smaller viewports.
- Scrollable content, buttons, and boolean toggles.
- Touch, mouse, and gamepad activation through TextButton.Activated.
- Explicit destruction and event cleanup.

## Install in Roblox Studio
1. Create a ModuleScript named `SproutUI` in ReplicatedStorage.
2. Replace its contents with `src/SproutUI.luau`.
3. Create a LocalScript in StarterPlayer > StarterPlayerScripts.
4. Paste `examples/Demo.client.luau` into it and start Play mode.

## API
`SproutUI.window(playerGui, {title = "Settings", width = 360, height = 300})`
returns a window with these methods:

- `window:button(text, callback)` returns a TextButton.
- `window:toggle(text, initialBoolean, callback)` returns a TextButton. The
  callback receives the new boolean after activation; it does not run initially.
- `window:destroy()` disconnects events and removes the ScreenGui; safe to repeat.

Callbacks run on the client. Validate all privileged actions on the server.
Use short labels; long labels can exceed the fixed button height.

## Validation status
The source and example were reviewed together. This package has NOT been run in
Roblox Studio or checked with the Luau analyzer. Studio checks below are required
before calling this a tested release. No users, downloads, or community adoption
are claimed. No association with Roblox or Anthropic is implied.

## Roadmap
- Complete the Studio checks and fix any type/runtime issues.
- Improve gamepad focus and keyboard navigation.
- Add theme configuration and flexible label heights.
- Add an optional icon adapter and a searchable example catalog.
- Gather feedback from developers and document real usage.

## Contributing
See CONTRIBUTING.md. Small reproducible bug reports and improvements welcome.
