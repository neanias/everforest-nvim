# Forest Flower Starship Configurations

Two powerline configurations available:

## 1. `forestflower.toml` - Full Version

**Pros:**
- Consistent segment spacing
- Supports many languages (14+)
- Predictable layout

**Cons:**
- Shows empty sage/blue segment when no language detected
- More visual "weight"

**Use if:** You like consistent spacing and work with many languages

## 2. `forestflower-clean.toml` - Clean Version ⭐ **Recommended**

**Pros:**
- No empty segments (cleaner look)
- Language segment only appears when detected
- Simplified to common languages (Node, Python, Rust, Go)
- Includes command prompt character

**Cons:**
- Variable prompt width (segments come/go)
- Fewer language detectors

**Use if:** You want a minimal, clean prompt without empty spaces

## The Empty Segment Explained

In your screenshot, the 4th **sage/blueish** segment is for **programming languages**.

It appears empty because:
1. Starship detected the directory structure
2. But no language was found (or Node.js wasn't in PATH)
3. The full config shows the segment background even when empty

## Installation

### Option 1: Clean Config (Recommended)
```bash
cp extras/starship/forestflower-clean.toml ~/.config/starship.toml
exec $SHELL
```

### Option 2: Full Config
```bash
cp extras/starship/forestflower.toml ~/.config/starship.toml
exec $SHELL
```

## Testing in Bento Directory

If `bento` has `package.json`, the Node.js icon should appear:

```bash
cd ~/Developer/bento
# Should show:  Node v20.x.x (or your version)
```

If it doesn't show:
1. Check Node.js is installed: `node --version`
2. Check package.json exists: `ls package.json`
3. Try clean config (better detection)

## Customizing

Add more languages to clean config:

```toml
[java]
symbol = " "
style = "bg:#89b4a8 fg:#101010"
format = '[](bg:#89b4a8)[ $symbol ($version) ]($style)[](fg:#89b4a8)'
```

## Visual Comparison

**Full Config:**
```
🟣 user  🌺 ~/dir  🌼  branch  🌿 [empty]  🏺 14:30
```

**Clean Config:**
```
🟣 user  🌺 ~/dir  🌼  branch  🏺 14:30
(no empty segment!)
```

**Clean Config with Node:**
```
🟣 user  🌺 ~/bento  🌼  main  🌿  v20.0.0  🏺 14:30
```

## Recommendation

Start with `forestflower-clean.toml` - it gives you the Forest Flower aesthetic without empty segments.
