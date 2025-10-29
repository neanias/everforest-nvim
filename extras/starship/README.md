# Forest Flower Starship Configuration

A clean, minimal powerline prompt for Starship using Forest Flower colors.

## Features

- **Clean 5-segment design:** Username, directory, git, languages, and time
- **Smart language detection:** Only shows when language files are detected (avoids empty segments)
- **Proper powerline arrows:** Uses Nerd Font glyphs for smooth transitions
- **Nature-inspired colors:** Hybrid hierarchical design using Forest Flower's semantic palette
- **Visual hierarchy:** Forest (green) → Flower (pink) → Water (cyan) → Sunset (orange)

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

1. **Username** (forest green) - Your username - Forest Flower's primary brand color
2. **Directory** (rose pink) - Current directory with icons
3. **Git** (twilight cyan) - Branch and status
4. **Languages** (sage green) - Detected language versions (when present)
5. **Time** (sunset orange) - Current time with heart icon

## Design Rationale

The color scheme uses a **hybrid hierarchical approach** that balances brand identity with visual hierarchy:

- **Forest Green** (`#b4d494`) for username: Forest Flower's primary brand color, represents identity
- **Rose Pink** (`#d699b6`) for directory: Tertiary color, warm and distinct context indicator
- **Twilight Cyan** (`#7fbbb3`) for git: Secondary color, clear visual separation from directory
- **Sage Green** (`#89b4a8`) for languages: Subtle metadata that appears only when relevant
- **Sunset Orange** (`#d9a85f`) for time: Warm warning color, functional but not demanding

This creates a natural color flow: **Forest → Flower → Water → Sunset** - mimicking a day in nature.

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
