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
    
    -- Treesitter highlight groups
    ["@keyword"] = link("Keyword"),
    ["@keyword.function"] = link("Keyword"),
    ["@keyword.return"] = link("Keyword"),
    ["@keyword.operator"] = link("Keyword"),
    ["@conditional"] = link("Conditional"),
    ["@repeat"] = link("Repeat"),
    ["@label"] = link("Label"),
    ["@exception"] = link("Exception"),
    
    -- Functions
    ["@function"] = link("Function"),
    ["@function.builtin"] = link("Function"),
    ["@function.call"] = link("Function"),
    ["@method"] = link("Function"),
    ["@method.call"] = link("Function"),
    ["@constructor"] = link("Function"),
    
    -- Types
    ["@type"] = link("Type"),
    ["@type.builtin"] = link("Type"),
    ["@type.definition"] = link("Type"),
    ["@type.qualifier"] = link("Keyword"),
    
    -- Variables
    ["@variable"] = link("Variable"),
    ["@variable.builtin"] = link("Variable"),
    ["@variable.parameter"] = create(syntax.parameter, palette.none),
    ["@variable.member"] = create(syntax.property, palette.none),
    ["@property"] = create(syntax.property, palette.none),
    ["@field"] = create(syntax.field, palette.none),
    ["@constant"] = link("Constant"),
    ["@constant.builtin"] = link("Constant"),
    
    -- Strings and literals
    ["@string"] = link("String"),
    ["@string.escape"] = create(syntax.special, palette.none),
    ["@string.regexp"] = create(syntax.special, palette.none),
    ["@character"] = link("Character"),
    ["@number"] = link("Number"),
    ["@float"] = link("Float"),
    ["@boolean"] = link("Boolean"),
    
    -- Operators
    ["@operator"] = link("Operator"),
    ["@punctuation.delimiter"] = link("Delimiter"),
    ["@punctuation.bracket"] = link("Delimiter"),
    ["@punctuation.special"] = link("Special"),
    
    -- Comments
    ["@comment"] = link("Comment"),
    ["@comment.documentation"] = link("SpecialComment"),
    ["@comment.error"] = create(syntax.error, palette.none),
    ["@comment.warning"] = create(syntax.warn, palette.none),
    ["@comment.todo"] = link("Todo"),
    ["@comment.note"] = create(syntax.info, palette.none),
    
    -- Tags (HTML/JSX)
    ["@tag.builtin"] = link("Tag"),  -- HTML tags (div, span, etc.) - cyan
    ["@tag"] = create(syntax.jsx_component, palette.none),  -- React Components (PascalCase) - coral
    ["@tag.attribute"] = create(palette.warning, palette.none),  -- JSX attributes - orange
    ["@tag.delimiter"] = create(syntax.punctuation, palette.none),  -- <, >, /> - teal
    
    -- Markup (Markdown, etc.)
    ["@markup.heading"] = create(syntax.type, palette.none, { styles.bold }),
    ["@markup.strong"] = create(palette.none, palette.none, { styles.bold }),
    ["@markup.italic"] = create(palette.none, palette.none, { styles.italic }),
    ["@markup.strikethrough"] = create(palette.none, palette.none, { styles.strikethrough }),
    ["@markup.underline"] = create(palette.none, palette.none, { styles.underline }),
    ["@markup.link"] = create(syntax.special, palette.none, { styles.underline }),
    ["@markup.link.url"] = create(syntax.string, palette.none),
    ["@markup.raw"] = create(syntax.string, palette.none),
    ["@markup.list"] = link("Special"),
    
    -- Misc
    ["@namespace"] = create(syntax.namespace, palette.none),
    ["@macro"] = link("Macro"),
    ["@preproc"] = link("PreProc"),
    ["@include"] = link("Include"),
    ["@define"] = link("Define"),
    
    -- LSP Semantic Tokens
    ["@lsp.type.class"] = link("Type"),
    ["@lsp.type.decorator"] = link("Function"),
    ["@lsp.type.enum"] = link("Type"),
    ["@lsp.type.enumMember"] = link("Constant"),
    ["@lsp.type.function"] = link("Function"),
    ["@lsp.type.interface"] = link("Type"),
    ["@lsp.type.macro"] = link("Macro"),
    ["@lsp.type.method"] = link("Function"),
    ["@lsp.type.namespace"] = create(syntax.namespace, palette.none),
    ["@lsp.type.parameter"] = create(syntax.parameter, palette.none),
    ["@lsp.type.property"] = create(syntax.property, palette.none),
    ["@lsp.type.struct"] = link("Type"),
    ["@lsp.type.type"] = link("Type"),
    ["@lsp.type.typeParameter"] = link("Type"),
    ["@lsp.type.variable"] = link("Variable"),
    
    -- React/JSX/TSX Specific
    ["@constructor.tsx"] = create(syntax.jsx_component, palette.none),  -- React Components in TSX
    ["@constructor.jsx"] = create(syntax.jsx_component, palette.none),  -- React Components in JSX
    ["@variable.builtin.tsx"] = create(syntax.keyword, palette.none),  -- React, Fragment, etc.
    ["@variable.builtin.jsx"] = create(syntax.keyword, palette.none),  -- React, Fragment, etc.
    
    -- React Hooks (these are function calls that start with 'use')
    ["@function.call.tsx"] = link("Function"),  -- Function calls including hooks
    ["@function.call.jsx"] = link("Function"),  -- Function calls including hooks
    
    -- TypeScript/TSX specific
    ["@type.tsx"] = link("Type"),
    ["@type.builtin.tsx"] = link("Type"),
    ["@keyword.tsx"] = link("Keyword"),
    ["@keyword.jsx"] = link("Keyword"),
  }
end

