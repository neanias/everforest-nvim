# Forest Flower Starship Configuration

A clean, minimal powerline prompt for Starship using Forest Flower colors.

## Features

- **Clean 4-segment design:** Username, directory, git, and time
- **No language detection:** Avoids empty segments
- **Proper powerline arrows:** Uses Nerd Font glyphs for smooth transitions
- **Nature-inspired colors:** Matches Forest Flower theme palette

## Installation

```bash
cp extras/starship/forestflower.toml ~/.config/starship.toml
exec $SHELL
```

Or use the provided install script from the project root:

```bash
./install-configs.sh
```

## Requirements

- **Starship:** Install from https://starship.rs
- **Nerd Font:** Any Nerd Font (e.g., GeistMono Nerd Font, JetBrains Mono Nerd Font)
- **Ghostty/Terminal:** Configure to use a Nerd Font

## Segments

1. **Username** (lavender/purple) - Your username
2. **Directory** (rose/pink) - Current directory with icons
3. **Git** (champak gold/yellow) - Branch and status
4. **Time** (warm brown) - Current time with heart icon

## Customization

### Add Language Detection

If you want to show programming language versions, add to the config:

```toml
# Add to format string (after $git_status):
$nodejs\
[](fg:#d9a85f bg:#89b4a8)\

# Add module configuration:
[nodejs]
symbol = ""
style = "bg:#89b4a8 fg:#101010"
format = '[ $symbol ($version) ]($style)'
```

Supported languages: `nodejs`, `python`, `rust`, `golang`, `java`, `ruby`, etc.

### Change Directory Icons

Edit the `[directory.substitutions]` section:

```toml
[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Projects" = " "
```

### Adjust Truncation

Change how deep the directory path shows:

```toml
[directory]
truncation_length = 3  # Show 3 levels
truncation_symbol = "…/"
```

## Troubleshooting

**Arrows show as boxes:**
- Install a Nerd Font
- Configure your terminal to use it
- Test: `echo -e "\ue0b0 \ue0b2 \ue0b1"`

**Prompt not updating:**
- Run `exec $SHELL` to reload
- Check config location: `echo $STARSHIP_CONFIG` (should be `~/.config/starship.toml`)

**Colors look wrong:**
- Ensure terminal supports 24-bit color
- Check Ghostty theme is set: `theme = /path/to/forestflower/extras/ghostty/forestflower`
