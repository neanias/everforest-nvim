# Font Verification Guide for Forest Flower

## Quick Test

Run this in your terminal:
```bash
echo "   "
```

**Expected:** You should see 4 solid triangle/arrow symbols  
**If you see:** Boxes (□) or question marks (?) → Font not working

## Verify Installation

### 1. Check Font Files
```bash
ls ~/Library/Fonts/ | grep GeistMono
```

Should show files like:
- `GeistMonoNerdFont-Regular.otf` ✓
- `GeistMonoNerdFont-Bold.otf` ✓

### 2. Check Ghostty Config
```bash
cat ~/.config/ghostty/config | grep font-family
```

Should show:
```
font-family = "GeistMono Nerd Font"
```

**NOT:**
```
font-family = "GeistMono"  ← Missing "Nerd Font"
```

### 3. Test Nerd Font Symbols

Run this test:
```bash
cat << 'EOF'
Powerline Arrows:    
Git Symbols:  
Common Icons:   󰈙 
EOF
```

All symbols should appear properly (not as boxes).

## Troubleshooting

### Issue: Boxes/Question Marks Instead of Symbols

**Cause:** Font not properly configured in Ghostty

**Fix:**
1. Edit `~/.config/ghostty/config`
2. Change from `"GeistMono"` to `"GeistMono Nerd Font"`
3. Restart Ghostty with `Cmd+Q`, then reopen

### Issue: Starship Colors Wrong

**Cause:** Terminal not loading theme

**Check:**
```bash
cat ~/.config/ghostty/config | grep theme
```

Should show:
```
theme = /Users/yajanarao/Developer/forestflower/extras/ghostty/forestflower
```

### Issue: Prompt Not Showing

**Cause:** Starship not initialized

**Fix:** Add to your shell config (`~/.zshrc` or `~/.bashrc`):
```bash
eval "$(starship init zsh)"  # for zsh
# or
eval "$(starship init bash)" # for bash
```

## Expected Result

After proper setup, you should see a colorful powerline prompt like:

```
┌─[🟣 yajanarao] [🌺 ~/Developer/forestflower] [🌼  main] [🌿  node v20] [🏺 14:30]
└─$
```

With smooth arrow transitions between segments (  ).

## Font Variants

GeistMono Nerd Font has several variants:

- `GeistMono Nerd Font` - Variable width (proportional)
- `GeistMono Nerd Font Mono` - Fixed width (recommended for terminal)
- `GeistMono Nerd Font Propo` - Proportional spacing

**Recommended for terminal:** `GeistMono Nerd Font Mono`

## Testing Starship Directly

```bash
# Test prompt rendering
starship prompt

# Test specific module
starship module directory
starship module git_branch
```

## Full Config Verification

Your `~/.config/ghostty/config` should have:

```conf
# Fonts - Use Nerd Font variant
font-family = "GeistMono Nerd Font"
font-family-bold = "GeistMono Nerd Font"

# Theme - Forest Flower
theme = /Users/yajanarao/Developer/forestflower/extras/ghostty/forestflower

# Shell Integration (optional)
shell-integration = detect
```

## Still Not Working?

1. **Completely quit Ghostty** (Cmd+Q, not just close window)
2. **Verify font installation:** `ls ~/Library/Fonts/ | grep Geist`
3. **Check Starship config:** `cat ~/.config/starship.toml | head -20`
4. **Test in another terminal:** Try iTerm2 or Terminal.app to isolate issue
5. **Reinstall Nerd Font:**
   ```bash
   brew reinstall font-geist-mono-nerd-font
   ```

## Success Checklist

- [ ] GeistMono Nerd Font files in `~/Library/Fonts/`
- [ ] Ghostty config uses `"GeistMono Nerd Font"`
- [ ] Forest Flower theme loaded in Ghostty
- [ ] Starship config at `~/.config/starship.toml`
- [ ] Starship initialized in shell config
- [ ] Symbols display correctly (run test above)
- [ ] Colors match Forest Flower palette

If all checked, your setup is complete! 🎨✨
