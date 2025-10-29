# Forest Flower Starship Configuration

A warm, nature-inspired powerline prompt for [Starship](https://starship.rs/) that matches the Forest Flower colorscheme aesthetic.

## Preview

The prompt features a flowing powerline design with warm, natural colors:
- 🟣 **Kurinji Purple** - User/OS
- 🌺 **Hibiscus Coral** - Directory
- 🌼 **Champak Gold** - Git info
- 🌿 **Warm Sage** - Programming languages
- 🌤️ **Warm Sky** - Docker/Tools
- 🏺 **Dark Terracotta** - Time

## Installation

### Prerequisites

- [Starship](https://starship.rs/) installed
- A [Nerd Font](https://www.nerdfonts.com/) installed and enabled in your terminal
- Recommended: Ghostty with Forest Flower theme for full aesthetic match

### Setup

1. **Copy the configuration:**

```bash
# Option 1: Use as your main starship config
cp forestflower.toml ~/.config/starship.toml

# Option 2: Include in existing config (add to your starship.toml)
# [insert content of forestflower.toml]
```

2. **For Ghostty users:**

Add to your `~/.config/ghostty/config`:

```conf
# Load Forest Flower theme
theme = forestflower

# Optional: Starship integration
command = /bin/zsh  # or your shell
shell-integration = true
```

3. **Reload your shell:**

```bash
exec $SHELL
```

## Customization

### Disable/Enable Sections

```toml
# Show OS symbol instead of username
[username]
disabled = true

[os]
disabled = false

# Disable time
[time]
disabled = true
```

### Adjust Truncation

```toml
[directory]
truncation_length = 5  # Show more path segments
truncation_symbol = ".../"
```

### Add More Languages

```toml
[python]
symbol = " "
style = "bg:#89b4a8 fg:#101010"
format = '[ $symbol ($version) ]($style)'
```

## Color Palette

The configuration uses Forest Flower's warm, nature-inspired palette:

| Element | Color | Hex | Inspiration |
|---------|-------|-----|-------------|
| User/OS | Kurinji purple | `#c4a7e7` | Purple wildflowers |
| Directory | Hibiscus coral | `#ea9a97` | Coral hibiscus blooms |
| Git | Champak gold | `#d9a85f` | Golden champak flowers |
| Languages | Warm sage | `#89b4a8` | Sage leaves |
| Docker/Tools | Warm sky | `#8fb4b3` | Twilight sky |
| Time | Dark terracotta | `#a67c52` | Earth clay |

## Philosophy

Like the Forest Flower colorscheme, this configuration follows:
- **Warm tones** - Reduced eye strain, natural aesthetic
- **Nature-inspired** - Colors from flowers and earth
- **Mindful design** - Clean, focused information hierarchy
- **Consistency** - Matches your Neovim lualine theme

## Compatibility

Works beautifully with:
- ✅ Forest Flower Neovim theme
- ✅ Forest Flower Ghostty theme
- ✅ Forest Flower lualine theme
- ✅ Any terminal supporting 24-bit color

## Tips

1. **Nerd Font Icons** - Ensure your font supports the icons (  etc.)
2. **True Color** - Your terminal should support 24-bit color
3. **Testing** - Try `starship config` to test changes before saving
4. **Performance** - Disable language detection in large repos if needed

## Troubleshooting

**Icons not showing?**
- Install a Nerd Font and configure your terminal to use it

**Colors look wrong?**
- Ensure your terminal supports true color (24-bit)
- Check terminal theme isn't overriding colors

**Prompt too long?**
- Adjust `truncation_length` in directory section
- Disable sections you don't use

## Contributing

Found an issue or want to improve the prompt? Submit a PR to the main Forest Flower repo!

## License

MIT - Same as Forest Flower colorscheme
