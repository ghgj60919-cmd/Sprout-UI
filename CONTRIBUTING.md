# Contributing

Open an issue describing the problem, expected behavior, and Studio reproduction
steps. For changes, keep the module dependency-free, include a runnable example,
and describe manual checks performed. Do not include private place files,
credentials, copied proprietary code, or unlicensed assets.

## Studio acceptance checks (not yet executed)
- Run the demo in Play mode: one panel and three controls appear.
- Activate Say hello: one message appears per activation.
- Activate Music twice: values print true, then false; label follows state.
- Add enough buttons to overflow: the content scrolls to the last control.
- Test phone portrait/landscape in Device Emulator: panel stays on screen.
- Replace CurrentCamera: resizing still updates the panel.
- Close the panel, then resize: no errors or residual GUI remain.
- Call destroy twice: no error. Adding a control after destruction must fail.
- Destroy the ScreenGui externally: viewport connections are cleaned up.
- Check Script Analysis and record remaining warnings in the issue.
