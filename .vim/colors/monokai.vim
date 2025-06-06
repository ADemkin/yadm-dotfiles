" File:       monokai.vim
" Maintainer: Anton Demkin (ademkin)
" URL:        https://github.com/ademkin/vim-monokai
" License:    MIT
"
" This color theme is a highly customized and based on original code from
" https://github.com/crusoexia/vim-monokai by Crusoe Xia (crusoexia)

" Initialisation
" --------------

if !has("gui_running") && &t_Co < 256
  finish
endif

if ! exists("g:monokai_gui_italic")
    let g:monokai_gui_italic = 1
endif

if ! exists("g:monokai_term_italic")
    let g:monokai_term_italic = 0
endif

let g:monokai_termcolors = 256 " does not support 16 color term right now.

" set background=dark
" hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "monokai"

function! s:h(group, style)
  let s:ctermformat = "NONE"
  let s:guiformat = "NONE"
  if has_key(a:style, "format")
    let s:ctermformat = a:style.format
    let s:guiformat = a:style.format
  endif
  if g:monokai_term_italic == 0
    let s:ctermformat = substitute(s:ctermformat, ",italic", "", "")
    let s:ctermformat = substitute(s:ctermformat, "italic,", "", "")
    let s:ctermformat = substitute(s:ctermformat, "italic", "", "")
  endif
  if g:monokai_gui_italic == 0
    let s:guiformat = substitute(s:guiformat, ",italic", "", "")
    let s:guiformat = substitute(s:guiformat, "italic,", "", "")
    let s:guiformat = substitute(s:guiformat, "italic", "", "")
  endif
  if g:monokai_termcolors == 16
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm16 : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm16 : "NONE")
  else
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
  end
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")      ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")      ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")      ? a:style.sp.gui   : "NONE")
    \ "gui="     (!empty(s:guiformat) ? s:guiformat   : "NONE")
    \ "ctermfg=" . l:ctermfg
    \ "ctermbg=" . l:ctermbg
    \ "cterm="   (!empty(s:ctermformat) ? s:ctermformat   : "NONE")
endfunction

" Palettes
" --------


let s:white       = { "gui": "#E8E8E3", "cterm": "252" }
let s:black       = { "gui": "#272822", "cterm": "234" }
let s:lightblack  = { "gui": "#2D2E27", "cterm": "235" }
let s:lightblack2 = { "gui": "#383a3e", "cterm": "236" }
let s:darkblack   = { "gui": "#211F1C", "cterm": "233" }
let s:grey        = { "gui": "#8F908A", "cterm": "243" }
let s:lightgrey   = { "gui": "#575b61", "cterm": "237" }
let s:darkgrey    = { "gui": "#64645e", "cterm": "239" }
let s:warmgrey    = { "gui": "#75715E", "cterm": "59"  }

let s:pink        = { "gui": "#F92772", "cterm": "197" }
let s:green       = { "gui": "#A6E22D", "cterm": "148" }
let s:aqua        = { "gui": "#66d9ef", "cterm": "81"  }
let s:yellow      = { "gui": "#E6DB74", "cterm": "186" }
let s:orange      = { "gui": "#FD9720", "cterm": "208" }
let s:purple      = { "gui": "#ae81ff", "cterm": "141" }
let s:red         = { "gui": "#e73c50", "cterm": "196" }
let s:darkred     = { "gui": "#5f0000", "cterm": "52"  }

let s:addfg       = { "gui": "#d7ffaf", "cterm": "193" }
let s:addbg       = { "gui": "#5f875f", "cterm": "65"  }
let s:delbg       = { "gui": "#f75f5f", "cterm": "167" }
let s:changefg    = { "gui": "#d7d7ff", "cterm": "189" }
let s:changebg    = { "gui": "#5f5f87", "cterm": "60"  }

let s:lightblue   = { "gui": "#a1efe4", "cterm": "117" }

" Highlighting
" ------------

set termguicolors
let g:terminal_ansi_colors = [
    \ s:black.gui, s:pink.gui, s:green.gui, s:yellow.gui,
    \ s:aqua.gui, s:purple.gui, s:lightblue.gui, s:white.gui,
    \ s:black.gui, s:pink.gui, s:green.gui, s:yellow.gui,
    \ s:aqua.gui, s:purple.gui, s:lightblue.gui, s:white.gui,
\ ]

" editor
call s:h("Normal",       { "fg": s:white,      "bg": s:black                           })
call s:h("ColorColumn",  { "bg": s:lightblack                                          })
call s:h("CursorColumn", { "bg": s:lightblack2                                         })
call s:h("CursorLine",   { "bg": s:lightblack                                          })
call s:h("NonText",      { "fg": s:lightgrey                                           })
call s:h("StatusLine",   { "fg": s:lightblack, "bg": s:white,     "format": "reverse"  })
call s:h("StatusLineNC", { "fg": s:lightblack, "bg": s:warmgrey,  "format": "reverse"  })
call s:h("TabLine",      { "fg": s:white,      "bg": s:darkblack, "format": "reverse"  })
call s:h("Visual",       { "bg": s:lightgrey                                           })
call s:h("Search",       { "fg": s:black,      "bg": s:yellow                          })
call s:h("MatchParen",   { "fg": s:black,      "bg": s:purple                          })
call s:h("Question",     { "fg": s:yellow                                              })
call s:h("ModeMsg",      { "fg": s:yellow                                              })
call s:h("MoreMsg",      { "fg": s:yellow                                              })
call s:h("ErrorMsg",     { "fg": s:black,      "bg": s:red,       "format": "standout" })
call s:h("WarningMsg",   { "fg": s:red                                                 })
call s:h("VertSplit",    { "fg": s:darkgrey,   "bg": s:black                           })
call s:h("LineNr",       { "fg": s:grey,       "bg": s:lightblack                      })
call s:h("CursorLineNr", { "fg": s:orange,     "bg": s:lightblack                      })
call s:h("SignColumn",   { "bg": s:lightblack                                          })

" misc
call s:h("SpecialKey",    { "fg": s:pink   })
call s:h("Title",         { "fg": s:yellow })
call s:h("Directory",     { "fg": s:aqua   })

" diff
call s:h("DiffAdd",       { "fg": s:addfg,      "bg": s:addbg    })
call s:h("DiffDelete",    { "fg": s:black,      "bg": s:delbg    })
call s:h("DiffChange",    { "fg": s:changefg,   "bg": s:changebg })
call s:h("DiffText",      { "fg": s:black,      "bg": s:aqua     })

call s:h("diffRemoved",   { "fg": s:red   })
call s:h("diffAdded",     { "fg": s:green })

" fold
call s:h("Folded",        { "fg": s:warmgrey,   "bg": s:darkblack })
call s:h("FoldColumn",    {                     "bg": s:darkblack })
"        Incsearch"

" popup menu
call s:h("Pmenu",      { "fg": s:white,      "bg": s:lightblack   })
call s:h("PmenuSel",   { "fg": s:white,       "bg": s:lightblack2 })
call s:h("PmenuThumb", { "fg": s:lightblack, "bg": s:grey         })

" Generic Syntax Highlighting
" ---------------------------

call s:h("Constant",      { "fg": s:purple })
call s:h("Number",        { "fg": s:purple })
call s:h("Float",         { "fg": s:purple })
call s:h("Boolean",       { "fg": s:purple })
call s:h("Character",     { "fg": s:yellow })
call s:h("String",        { "fg": s:yellow })

call s:h("Type",          { "fg": s:aqua  })
call s:h("Structure",     { "fg": s:green })
call s:h("StorageClass",  { "fg": s:aqua  })
call s:h("Typedef",       { "fg": s:green })
call s:h("Identifier",    { "fg": s:white })
call s:h("Function",      { "fg": s:green })

call s:h("Statement",     { "fg": s:aqua   })
call s:h("Operator",      { "fg": s:aqua   })
call s:h("Label",         { "fg": s:purple })
call s:h("Keyword",       { "fg": s:aqua   })
"        Conditional"
"        Repeat"
"        Exception"

call s:h("PreProc",       { "fg": s:green  })
call s:h("Include",       { "fg": s:pink   })
call s:h("Define",        { "fg": s:pink   })
call s:h("Macro",         { "fg": s:green  })
call s:h("PreCondit",     { "fg": s:green  })
call s:h("Special",       { "fg": s:purple })
call s:h("SpecialChar",   { "fg": s:pink   })
call s:h("Delimiter",     { "fg": s:pink   })
call s:h("SpecialComment",{ "fg": s:aqua   })
call s:h("Tag",           { "fg": s:pink   })
"        Debug"

call s:h("Todo",          { "fg": s:orange,   "format": "bold,italic" })
call s:h("Comment",       { "fg": s:warmgrey, "format": "italic"      })
call s:h("Underlined",    { "fg": s:green                             })
call s:h("Ignore",        {                                           })
call s:h("Error",         { "fg": s:red, "bg": s:darkred              })

" NerdTree
" --------
call s:h("NERDTreeOpenable",        { "fg": s:yellow })
call s:h("NERDTreeClosable",        { "fg": s:yellow })
call s:h("NERDTreeHelp",            { "fg": s:yellow })
call s:h("NERDTreeBookmarksHeader", { "fg": s:pink   })
call s:h("NERDTreeBookmarksLeader", { "fg": s:black  })
call s:h("NERDTreeBookmarkName",    { "fg": s:yellow })
call s:h("NERDTreeCWD",             { "fg": s:pink   })
call s:h("NERDTreeUp",              { "fg": s:white  })
call s:h("NERDTreeDirSlash",        { "fg": s:grey   })
call s:h("NERDTreeDir",             { "fg": s:grey   })

" Syntastic
" ---------

hi! link SyntasticErrorSign Error
call s:h("SyntasticWarningSign",    { "fg": s:lightblack, "bg": s:orange })

" Language highlight
" ------------------

" Java properties
call s:h("jpropertiesIdentifier",   { "fg": s:pink })

" Vim command
call s:h("vimCommand",              { "fg": s:pink })

" Javascript
call s:h("javaScript",                          { "fg": s:white    })
call s:h("javaScriptBoolean",                   { "fg": s:purple   })
call s:h("javaScriptBraces",                    { "fg": s:white    })
call s:h("javaScriptBranch",                    { "fg": s:aqua     })
call s:h("javaScriptComment",                   { "fg": s:warmgrey })
call s:h("javaScriptCommentSkip",               { "fg": s:warmgrey })
call s:h("javaScriptCommentTodo",               { "fg": s:orange   })
call s:h("javaScriptConditional",               { "fg": s:pink     })
call s:h("javaScriptDeprecated",                { "fg": s:white    })
call s:h("javaScriptEmbed",                     { "fg": s:white    })
call s:h("javaScriptException",                 { "fg": s:pink     })
call s:h("javaScriptFunction",                  { "fg": s:aqua     })
call s:h("javaScriptGlobal",                    { "fg": s:white    })
call s:h("javaScriptIdentifier",                { "fg": s:aqua     })
call s:h("javaScriptLabel",                     { "fg": s:white    })
call s:h("javaScriptLineComment",               { "fg": s:warmgrey })
call s:h("javaScriptMember",                    { "fg": s:white    })
call s:h("javaScriptMessage",                   { "fg": s:white    })
call s:h("javaScriptNull",                      { "fg": s:purple   })
call s:h("javaScriptNumber",                    { "fg": s:purple   })
call s:h("javaScriptOperator",                  { "fg": s:pink     })
call s:h("javaScriptParens",                    { "fg": s:white    })
call s:h("javaScriptRegexpString",              { "fg": s:purple   })
call s:h("javaScriptRepeat",                    { "fg": s:pink     })
call s:h("javaScriptReserved",                  { "fg": s:aqua     })
call s:h("javaScriptSpecial",                   { "fg": s:white    })
call s:h("javaScriptSpecialCharacter",          { "fg": s:white    })
call s:h("javaScriptStatement",                 { "fg": s:pink     })
call s:h("javaScriptStringD",                   { "fg": s:yellow   })
call s:h("javaScriptStringS",                   { "fg": s:yellow   })
call s:h("javaScriptStringT",                   { "fg": s:yellow   })
call s:h("javaScriptType",                      { "fg": s:aqua     })

" Html
call s:h("htmlTag",                         { "fg": s:white  })
call s:h("htmlEndTag",                      { "fg": s:white  })
call s:h("htmlTagName",                     { "fg": s:pink   })
call s:h("htmlSpecialTagName",              { "fg": s:pink   })
call s:h("htmlArg",                         { "fg": s:green  })
call s:h("htmlSpecialChar",                 { "fg": s:purple })
call s:h("htmlScriptTag",                   { "fg": s:white  })
call s:h("htmlItalic",                      { "bg": s:black  })
call s:h("htmlItalicBold",                  { "bg": s:black  })

" Xml
call s:h("xmlTag",                          { "fg": s:white  })
call s:h("xmlEndTag",                       { "fg": s:white  })
call s:h("xmlTagName",                      { "fg": s:pink   })
call s:h("xmlAttrib",                       { "fg": s:green  })
call s:h("xmlProcessing",                   { "fg": s:white  })
call s:h("xmlProcessingDelim",              { "fg": s:orange })

" CSS
call s:h("cssProp",                         { "fg": s:yellow                               })
call s:h("cssUIAttr",                       { "fg": s:yellow                               })
call s:h("cssFunctionName",                 { "fg": s:aqua                                 })
call s:h("cssColor",                        { "fg": s:purple                               })
call s:h("cssPseudoClassId",                { "fg": s:purple                               })
call s:h("cssClassName",                    { "fg": s:green                                })
call s:h("cssValueLength",                  { "fg": s:purple                               })
call s:h("cssCommonAttr",                   { "fg": s:pink                                 })
call s:h("cssBraces" ,                      { "fg": s:white                                })
call s:h("cssClassNameDot",                 { "fg": s:pink                                 })
call s:h("cssURL",                          { "fg": s:orange, "format": "underline,italic" })

" LESS
call s:h("lessVariable",                    { "fg": s:green })

" ruby
call s:h("rubyInterpolationDelimiter",  {                })
call s:h("rubyInstanceVariable",        {                })
call s:h("rubyGlobalVariable",          {                })
call s:h("rubyClassVariable",           {                })
call s:h("rubyPseudoVariable",          {                })
call s:h("rubyFunction",                { "fg": s:green  })
call s:h("rubyStringDelimiter",         { "fg": s:yellow })
call s:h("rubyRegexp",                  { "fg": s:yellow })
call s:h("rubyRegexpDelimiter",         { "fg": s:yellow })
call s:h("rubySymbol",                  { "fg": s:purple })
call s:h("rubyEscape",                  { "fg": s:purple })
call s:h("rubyInclude",                 { "fg": s:pink   })
call s:h("rubyOperator",                { "fg": s:pink   })
call s:h("rubyControl",                 { "fg": s:pink   })
call s:h("rubyClass",                   { "fg": s:pink   })
call s:h("rubyDefine",                  { "fg": s:pink   })
call s:h("rubyException",               { "fg": s:pink   })
call s:h("rubyRailsARAssociationMethod",{ "fg": s:orange })
call s:h("rubyRailsARMethod",           { "fg": s:orange })
call s:h("rubyRailsRenderMethod",       { "fg": s:orange })
call s:h("rubyRailsMethod",             { "fg": s:orange })
call s:h("rubyConstant",                { "fg": s:aqua   })
call s:h("rubyBlockArgument",           { "fg": s:orange })
call s:h("rubyBlockParameter",          { "fg": s:orange })

" eruby
call s:h("erubyDelimiter",              {})
call s:h("erubyRailsMethod",            { "fg": s:aqua })

" c
call s:h("cLabel",                      { "fg": s:pink  })
call s:h("cStructure",                  { "fg": s:pink  })
call s:h("cStorageClass",               { "fg": s:pink  })
call s:h("cInclude",                    { "fg": s:green })
call s:h("cDefine",                     { "fg": s:green })

" python
call s:h("pythonConditional",           { "fg": s:pink    })
call s:h("pythonOperator",              { "fg": s:pink    })
call s:h("pythonStatement",             { "fg": s:aqua    })
call s:h("pythonRepeat",                { "fg": s:pink    })
call s:h("pythonException",             { "fg": s:pink    })
call s:h("pythonBuiltIn",               { "fg": s:aqua    })
call s:h("pythonAsync",                 { "fg": s:pink    })
call s:h("pythonAttribute",             { "fg": s:pink    })
call s:h("pythonSelf",                  { "fg": s:orange  })
call s:h("pythonFunction",              { "fg": s:green   }) " xxx links to Function
call s:h("pythonInclude",               { "fg": s:pink    }) "  xxx links to Include
call s:h("pythonDecorator",             { "fg": s:pink    }) " xxx links to Define
call s:h("pythonDecoratorName",         { "fg": s:green   }) " xxx links to Function
call s:h("pythonDoctestValue",          { "fg": s:pink    }) " xxx links to Define
call s:h("pythonMatrixMultiply",        { "fg": s:purple  }) " xxx cleared
call s:h("pythonTodo",                  { "fg": s:orange  }) " green or orange     xxx links to Todo
call s:h("pythonComment",               { "fg": s:grey    }) "  xxx links to Comment
call s:h("pythonQuotes",                { "fg": s:yellow  }) "   xxx links to String
call s:h("pythonEscape",                { "fg": s:purple  }) "   xxx links to Special
call s:h("pythonString",                { "fg": s:yellow  }) "   xxx links to String
call s:h("pythonTripleQuotes",          { "fg": s:yellow  }) " xxx links to pythonQuotes
call s:h("pythonSpaceError",            { "bg": s:darkred }) " xxx cleared
call s:h("pythonDoctest",               { "fg": s:purple  }) "  xxx links to Special
call s:h("pythonRawString",             { "fg": s:purple  }) " xxx links to String
call s:h("pythonNumber",                { "fg": s:purple  }) "   xxx links to Number
call s:h("pythonExceptions",            { "fg": s:aqua    }) " xxx links to Structure
call s:h("pythonSync",                  { "fg": s:purple  }) "     xxx cleared

" yaml
call s:h("yamlBlockMappingKey",         { "fg": s:white  })
call s:h("yamlInteger",                 { "fg": s:purple })
call s:h("yamlKeyValueDelimiter",       { "fg": s:pink   })
call s:h("yamlFlowMappingKey",          { "fg": s:white  })
call s:h("yamlFlowIndicator",           { "fg": s:pink   })
call s:h("yamlAlias",                   { "fg": s:green  })
call s:h("yamlBlockCollectionItemStart",{ "fg": s:pink   })
call s:h("yamlPlainScalar",             { "fg": s:green  })

" sh
call s:h("shLoop",                      { "fg": s:pink  })
call s:h("shConditional",               { "fg": s:pink  })
call s:h("shQuote",                     { "fg": s:white })
call s:h("shOperator",                  { "fg": s:white })
call s:h("shCommandSub",                { "fg": s:aqua  })
call s:h("shDo",                        { "fg": s:aqua  })
call s:h("shDerefSimple",               { "fg": s:aqua  })

" vimscript
call s:h("vimOper",                     { "fg": s:white })
call s:h("vimFuncName",                 { "fg": s:aqua  })
call s:h("vimFunction",                 { "fg": s:aqua  })
call s:h("vimFuncKey",                  { "fg": s:aqua  })
call s:h("vimFuncSID",                  { "fg": s:green })
call s:h("vimCommand",                  { "fg": s:pink  })
call s:h("vimlet",                      { "fg": s:green })
call s:h("vimOperParen",                { "fg": s:white })
call s:h("vimParenSep",                 { "fg": s:white })
call s:h("vimVar",                      { "fg": s:white })

" golang
" to use with: 'charlespascoe/vim-go-syntax'
call s:h("goKeywords",            { "fg": s:pink   })
call s:h("goParens",              { "fg": s:white  })
call s:h("goBraces",              { "fg": s:white  })
call s:h("goIf",                  { "fg": s:pink   })
call s:h("goFor",                 { "fg": s:pink   })
call s:h("goSliceOrArrayLiteral", { "fg": s:white  })
call s:h("goForRange",            { "fg": s:pink   })
call s:h("goUnderscore",          { "fg": s:white  })
call s:h("goBrackets",            { "fg": s:white  })
call s:h("goMapBrackets",         { "fg": s:white  })
call s:h("goImportedPackages",    { "fg": s:white  })
call s:h("goPackage",             { "fg": s:pink   })
call s:h("goImport",              { "fg": s:pink   })
call s:h("goPackageName",         { "fg": s:white  })
call s:h("goType",                { "fg": s:orange })
call s:h("goTypeDeclName",        { "fg": s:green  })
call s:h("goNonPrimitiveType",    { "fg": s:white  })
call s:h("goNonPrimitiveType",    { "fg": s:orange })
call s:h("goSliceOrArrayType",    { "fg": s:white  })
call s:h("goBuiltins",            { "fg": s:aqua   })
call s:h("goPointer",             { "fg": s:pink   })
call s:h("goOperator",            { "fg": s:pink   })
call s:h("goDot",                 { "fg": s:white  })
call s:h("goNil",                 { "fg": s:purple })
call s:h("goStringFormat",        { "fg": s:purple })
call s:h("goStringEscape",        { "fg": s:purple })
call s:h("goFuncCall",            { "fg": s:aqua   })
call s:h("goFuncReturnType",      { "fg": s:orange })
call s:h("goReturn",              { "fg": s:pink   })
call s:h("goSwitch",              { "fg": s:pink   })
call s:h("goSwitchTypeBlock",     { "fg": s:pink   })
call s:h("goCase",                { "fg": s:pink   })
call s:h("goLabel",               { "fg": s:pink   })
call s:h("goVarDecl",             { "fg": s:pink   })
call s:h("goStructTypeTag",       { "fg": s:yellow })
call s:h("goTypeDeclName",        { "fg": s:green  })
call s:h("goStructType",          { "fg": s:purple })
call s:h("goInterfaceType",       { "fg": s:purple })
call s:h("goInterfaceMethod",     { "fg": s:white  })

" toml
call s:h("tomlKey",                     { "fg": s:white  })
call s:h("tomlTable",                   { "fg": s:aqua   })
call s:h("tomlTableArray",              { "fg": s:green  })
call s:h("tomlDotInKey",                { "fg": s:white  })
call s:h("tomlString",                  { "fg": s:yellow })
call s:h("tomlKeyValueArray",           { "fg": s:white  })
call s:h("tomlBoolean",                 { "fg": s:purple })
call s:h("tomlInteger",                 { "fg": s:purple })

" shell
call s:h("shOption",                    { "fg": s:white })

" docker
call s:h("dockerfileKeyword",           { "fg": s:pink  })
call s:h("dockerfileFrom",              { "fg": s:white })
call s:h("dockerfileShell",             { "fg": s:white })

" sql
call s:h("sqlSnippet",                  { "fg": s:white  })
call s:h("sqlStatement",                { "fg": s:purple })
call s:h("sqlKeyword",                  { "fg": s:purple })
call s:h("sqlSpecial",                  { "fg": s:purple })

" zsh
call s:h("zshConditional", { "fg": s:pink })
call s:h("zshCommands",    { "fg": s:pink })


" lightline
if !exists("g:lightline")
    finish
endif

function! s:unpack2ll(color)
    return [a:color.gui, a:color.cterm]
endfunction

let s:ll_black  = [ '#30302c', 236 ]
let s:ll_grey1  = [ '#4e4e43', 239 ]
let s:ll_grey2  = [ '#666656', 242 ]
let s:ll_grey3  = [ '#808070', 244 ]
let s:ll_grey4  = [ '#949484', 246 ]
let s:ll_white  = s:unpack2ll(s:white)
let s:ll_yellow = s:unpack2ll(s:yellow)
let s:ll_purple = s:unpack2ll(s:purple)
let s:ll_red    = s:unpack2ll(s:red)
let s:ll_pink   = s:unpack2ll(s:pink)
let s:ll_aqua   = s:unpack2ll(s:aqua)
let s:ll_green  = s:unpack2ll(s:green)

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:ll_black,  s:ll_aqua ],   [ s:ll_white, s:ll_grey1 ] ]
let s:p.normal.right    = [ [ s:ll_black,  s:ll_grey4 ],  [ s:ll_grey4, s:ll_grey1 ] ]
let s:p.inactive.right  = [ [ s:ll_black,  s:ll_grey2 ],  [ s:ll_grey3, s:ll_black ] ]
let s:p.inactive.left   = [ [ s:ll_grey3,  s:ll_black ],  [ s:ll_grey2, s:ll_black ] ]
let s:p.insert.left     = [ [ s:ll_black,  s:ll_green ],  [ s:ll_white, s:ll_grey1 ] ]
let s:p.replace.left    = [ [ s:ll_black,  s:ll_yellow ], [ s:ll_white, s:ll_grey1 ] ]
let s:p.visual.left     = [ [ s:ll_black,  s:ll_purple ], [ s:ll_white, s:ll_grey1 ] ]
let s:p.normal.middle   = [ [ s:ll_grey3,  s:ll_black ] ]
let s:p.inactive.middle = [ [ s:ll_grey2,  s:ll_black ] ]
let s:p.tabline.left    = [ [ s:ll_white,  s:ll_grey2] ]
let s:p.tabline.tabsel  = [ [ s:ll_white,  s:ll_black ] ]
let s:p.tabline.middle  = [ [ s:ll_grey1,  s:ll_grey4 ] ]
let s:p.tabline.right   = copy(s:p.normal.right)
let s:p.normal.error    = [ [ s:ll_red,    s:ll_black ] ]
let s:p.normal.warning  = [ [ s:ll_yellow, s:ll_grey1 ] ]

let g:lightline#colorscheme#monokai#palette = lightline#colorscheme#flatten(s:p)
