---Syntax highlighting groups
---Core syntax highlighting for programming languages

local highlights = require("forestflower.core.highlights")

---@param theme ForestflowerTheme
---@param config ThemeConfig
---@return Highlights
return function(theme, config)
  local palette, ui, syntax = theme.palette, theme.ui, theme.syntax
  local create = highlights.create
  local link = highlights.link
  local styles = highlights.styles

  local comment_italics = config.disable_italic_comments and {} or { styles.italic }
  local optional_italics = config.italics and { styles.italic } or {}

  return {
    -- Basic syntax
    Comment = create(syntax.comment, palette.none, comment_italics),
    SpecialComment = link("Comment"),
    
    -- Keywords
    Keyword = create(syntax.keyword, palette.none, optional_italics),
    Conditional = link("Keyword"),
    Repeat = link("Keyword"),
    Label = create(syntax.type, palette.none),
    Exception = link("Keyword"),
    Statement = link("Keyword"),
    PreProc = link("Keyword"),
    PreCondit = link("Keyword"),
    Include = link("Keyword"),
    Define = link("Keyword"),
    Macro = create(syntax.macro, palette.none, optional_italics),
    
    -- Types
    Type = create(syntax.type, palette.none),
    Typedef = link("Type"),
    StorageClass = link("Type"),
    Structure = link("Type"),
    
    -- Functions
    Function = create(syntax["function"], palette.none),
    Method = link("Function"),
    
    -- Variables
    Identifier = create(ui.fg, palette.none),
    Variable = create(syntax.variable, palette.none),
    Constant = create(syntax.constant, palette.none),
    
    -- Strings and numbers
    String = create(syntax.string, palette.none),
    Character = link("String"),
    Number = create(syntax.number, palette.none),
    Float = link("Number"),
    Boolean = create(syntax.boolean, palette.none),
    
    -- Operators
    Operator = create(syntax.operator, palette.none),
    Special = create(syntax.special, palette.none),
    SpecialChar = link("Special"),
    
    -- Tags
    Tag = link("Type"),
    
    -- Delimiters
    Delimiter = create(syntax.punctuation, palette.none),
    
    -- Underlined
    Underlined = create(palette.none, palette.none, { styles.underline }),
    
    -- Error
    Error = create(syntax.error, palette.none),
    
    -- Todo
    Todo = create(syntax.todo, palette.none, { styles.bold }),
    
    -- Ignore
    Ignore = link("Comment"),
  }
end

