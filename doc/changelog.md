## Unreleased
- BREAKING: Core highlight definitions migrated to role-based theme tables (`ui`, `syntax`). Direct palette references reduced; override via `roles_override` / `syntax_override` or `on_highlights`.
- Added config: `contrast_audit` to emit a contrast summary via `vim.notify`.
- Added UI role fields (float_*, popup_background, selection, scrollbar_thumb, statusline_*, tab_*).

## Mini Tabline

Highlight the current tab in the tabline with the color same as the background color of the tab.
