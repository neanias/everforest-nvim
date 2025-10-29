# Fix Ghostty Configuration

## Issue 1: Shell Integration Error

**Error:** `shell-integration: invalid value "true"`

**Fix:** Edit `~/.config/ghostty/config` and change:

```
# WRONG:
shell-integration = true

# CORRECT:
shell-integration = detect
```

Or remove the line entirely (detect is default).

## Issue 2: Powerline Arrows Not Showing

**Problem:** You're seeing regular characters instead of powerline arrows (  )

**Cause:** Your font doesn't have Nerd Font symbols

**Solution:** Install and use a Nerd Font

### Option 1: Use GeistMono Nerd Font (matches your current font)

```bash
# Install via Homebrew
brew tap homebrew/cask-fonts
brew install font-geist-mono-nerd-font
```

Then update `~/.config/ghostty/config`:

```
font-family = "GeistMono Nerd Font"
```

### Option 2: Use other Nerd Fonts

```bash
# JetBrains Mono Nerd Font
brew install font-jetbrains-mono-nerd-font

# Fira Code Nerd Font  
brew install font-fira-code-nerd-font

# Cascadia Code Nerd Font
brew install font-caskaydia-cove-nerd-font
```

### Verify Nerd Font Installation

After installing, test in terminal:
```bash
echo "   "
```

You should see proper arrow symbols.

## Quick Fix Steps

1. **Edit Ghostty config:**
```bash
nano ~/.config/ghostty/config
```

2. **Remove or fix this line:**
```
# Remove this:
shell-integration = true

# Or change to:
shell-integration = detect
```

3. **Add Nerd Font:**
```
font-family = "GeistMono Nerd Font"
```

4. **Restart Ghostty**

## Your Corrected Config Should Look Like:

```
# Fonts
font-family = "GeistMono Nerd Font"
font-family-bold = "GeistMono Nerd Font"
font-family-italic = "Maple Mono"
font-family-bold-italic = "Maple Mono"
font-size = 14
adjust-underline-position = 4

# Mouse
mouse-hide-while-typing = true

# Alt
macos-option-as-alt = true

# Theme
theme = /Users/yajanarao/Developer/forestflower/extras/ghostty/forestflower
cursor-invert-fg-bg = true
window-theme = ghostty

# Shell Integration (optional)
shell-integration = detect

# Window
gtk-single-instance = true
gtk-tabs-location = bottom
gtk-wide-tabs = false
gtk-toolbar-style = flat
window-padding-y = 2,0
window-padding-balance = true
```

## Test Starship

After fixing, restart Ghostty and run:
```bash
starship config
```

You should see beautiful powerline arrows with Forest Flower colors!
