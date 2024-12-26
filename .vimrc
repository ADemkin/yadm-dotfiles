" generic vimrc
set nocompatible
syntax on
set encoding=utf-8
set colorcolumn=80

" allow to auto indent and auto tab
filetype on
filetype indent on
filetype plugin on

" tabs and spaces
set autoindent
set tabstop=4
set shiftwidth=0
set smarttab
set expandtab
set nojoinspaces
set list
set listchars=tab:\¦\ ,trail:·

autocmd Filetype html,vue,htmldjango setlocal ts=4 sw=4 sts=4 expandtab matchpairs+=<:>
autocmd FileType sh iabbrev #! #!/bin/sh
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd FileType python setlocal ts=4 sw=4 sts=0 nolist expandtab
autocmd FileType markdown setlocal conceallevel=0
autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=0 nolist noexpandtab

" Python: additional language settings
" Additional python highlight for monokai
autocmd FileType python syn match pythonSelf "\(\W\|^\)\@<=\(self\|cls\)\([\.,:)]\)\@="
autocmd FileType python syn match pythonOperator "\(:\?[<>=\-%+\*!|&^]\)"
autocmd FileType python syn match pythonNumber "\(\[\d_]*\)\b"
" autocomplete
autocmd FileType python iabbrev pdb import pdb ; pdb.set_trace();<CR>pass
autocmd FileType python iabbrev ifname if __name__ == '__main__':<CR>

" file handling
" set isfname-=:
set noswapfile  " do not create *.sw[op] files
set autoread  " auto reload file when it's updated

" number column
set number
set relativenumber
set numberwidth=1
" Automatically split or merge signcolumn depending on the window width
function! UpdateSignColumn() abort
    if &buftype == 'terminal'
        setlocal signcolumn=no nonumber norelativenumber
    elseif winwidth(winnr()) > &colorcolumn + 10
        setlocal signcolumn=auto
    else
        setlocal signcolumn=number
    endif
endfunction
autocmd WinResized * call UpdateSignColumn()

" show cursor line
set cursorline

" highlight errors with red bg
highlight SpellBad ctermbg=52 cterm=none

set ttyfast
set showcmd " display incomplete command
set completeopt=menu,menuone,noinsert,noselect
set gdefault  " g is not required by default in :s/old/new/ command
set scrolloff=3
set undodir=~/.vim/undo
set mouse=  " Allow to select raw text from vim
set laststatus=2  " always display the status line
set visualbell
set splitright  " :vs split to right
set splitbelow  " :sp split to bottom
set backspace=indent,eol,start  " Backspace deletes like most programs in insert mode
set textwidth=0  " prevent from auto-newline
set nofoldenable  " disable code folding

" Paste mode settings
set showmode  " show if paste mode is on

" vertical split appearance
set fillchars+=vert:\│

" set colors
set background=dark
set termguicolors

" ignore case while searching
set ignorecase
set smartcase
set hlsearch
set incsearch
" highlight with yellow on black
highlight MatchParen ctermbg=yellow

" (re)store session on exit
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Let menu act like shell
set wildmenu
set wildmode=list:longest,full
set wildignore=**/_build/*,**/tags,**/.git,**/.hypothesis
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
set wildignore+=**/*.egg-info,**/.*_cache
set wildignore+=**/__pychache__

" Add fzf to completions
" set rtp+=/opt/homebrew/opt/fzf

" Map Space as Leader
nnoremap <SPACE> <Nop>
map <Space> <Leader>

" move visual selection up and down with J/K
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" do not require shift for :
nmap ; :

" easy movement between panes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Terminal settings
" nvim and vim configs are different
if !has('nvim')
    " vim9 config
    nmap <leader>t :vert term<CR>
    " easy movement for terminal
    tnoremap <C-j> <C-w>j
    tnoremap <C-k> <C-w>k
    tnoremap <C-l> <C-w>l
    tnoremap <C-h> <C-w>h
    " C-u like regular terminal
    " for some reason autocommand with nonu nornu sometimes will also
    " affect other buffer, which is unwanted behaviour. Ti fix that manually set
    " nonu nornu when star scroll
    " tnoremap <C-u> <C-w>:set nonu nornu<CR><C-w><S-n><C-u>
    tnoremap <C-u> <C-w><S-n><C-u>
    " Leave Terminal Normal mode my enter
    nnoremap <Return> i
    " Do not show line number in terminal in any mode
    " autocmd TerminalOpen * setlocal listchars= nonumber norelativenumber
    autocmd TerminalOpen * startinsert
    " autocmd TerminalOpen * setlocal nonumber norelativenumber
    " selected terminal statusline
    " highlight StatusLineTerm ctermbg=black ctermfg=white
    " unselected terminal statusline
    " highlight StatusLineTermNC ctermbg=black ctermfg=grey
else
    " nterm
    " nvim has differen terminal binding
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l
    autocmd TerminalOpen * startinsert
endif


" Dark style for popup window
highlight Pmenu ctermbg=black ctermfg=white

" clear highlight
" (overriden in Mark plugin settings)
map <leader>c :nohlsearch<CR>

" spell check
set spelllang=en_gb,ru
autocmd FileType txt setlocal spell
autocmd FileType rst setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" additional error highlight
call matchadd('Error', '\s+$')

" Show syntax highlighting groups for word under cursor
nmap <leader>w :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Show buffer and expect to enter buffer number
nmap <leader>b :buffers<cr>:buffer<space>

" ###################### VIM PLUGINS AND SETTINGS #############################
"
" VimPlug
"
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" or autoinstall it:
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" more info on VimPlug on https://github.com/junegunn/vim-plug
"
call plug#begin()

" NERDTree: sidebar to navigate project
Plug 'scrooloose/nerdtree'

" NerdTreeGitPlugin: show git status in NerdTree
" old one, no longer maintained
Plug 'Xuyuanp/nerdtree-git-plugin'
" new one, maintained
" Plug 'albfan/nerdtree-git-plugin'

" Fugitive: do git blame and git diff from vim directly
Plug 'tpope/vim-fugitive'

" Commentary: comment code with ease
Plug 'tpope/vim-commentary'

" Abolish: swap case with cr* and use smart :S instead of :s
Plug 'tpope/vim-abolish'

" IndentLine: add vertical line on on indent
Plug 'Yggdroot/indentLine'

" SurrondWith: effective way to 'surround' str(code)
Plug 'tpope/vim-surround'

" Mark: <leader>-m to highlight word
Plug 'idbrii/vim-mark'
" requirements
Plug 'inkarkat/vim-ingo-library'

" ALE: async linter with multiple language support
Plug 'dense-analysis/ale'

" LSC: Fastest LSP client
Plug 'natebosch/vim-lsc'

" VimCompletesMe: Use Tab for autocomplete
" Plug 'vim-scripts/VimCompletesMe'

" FZF: Search files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" VimTmuxNavigator: Seamlessly move between vim and tmux panes
Plug 'christoomey/vim-tmux-navigator'

" TreeSitter: nvim godly syntax match
if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" VimAutoFormat: format file automatically
Plug 'vim-autoformat/vim-autoformat'

" Emmet: html plugin
Plug 'mattn/emmet-vim'

" Undotree: visualise undo history
Plug 'mbbill/undotree'

" Markdown: syntax, tabs and render
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
" If you don't have nodejs and yarn
" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
" see: https://github.com/iamcco/markdown-preview.nvim/issues/50
" run :MarkdownPreview to run web browser in sync with vim
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" VimSneak: Easy and smart movements with s key
Plug 'justinmk/vim-sneak'

" Copilot: AI completion tool
Plug 'github/copilot.vim'

" Lightline: fast configurable statusline
Plug 'itchyny/lightline.vim'

" ColorTemplate: convert colorscheme to template
Plug 'lifepillar/vim-colortemplate'

" VimRepeat: repeat surround and other stuff with .
Plug 'tpope/vim-repeat'

" Argwrap: Split/Unsplit text in brackets
Plug 'FooSoft/vim-argwrap'

" EasyAlign: align text with ease
Plug 'junegunn/vim-easy-align'

" Timelapse: git history fun
Plug 'vim-scripts/git-time-lapse'

" Signify: show diff in gutter, jump and undo hunks
Plug 'mhinz/vim-signify'

" Codefmt: format code with google codefmt
" " Add maktaba and codefmt to the runtimepath.
" " (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" " Also add Glaive, which is used to configure codefmt's maktaba flags. See
" " `:help :Glaive` for usage.
Plug 'google/vim-glaive'

" GoSyntax: enhance go syntax
Plug 'charlespascoe/vim-go-syntax'

" AutoPairs: auto close brackets
Plug 'jiangmiao/auto-pairs'

" Endwise: auto close end in vim and sh
Plug 'tpope/vim-endwise'

" Dadbod: database client
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion' "Optional
Plug 'tpope/vim-dotenv'

call plug#end()
call glaive#Install()

" NERDTree: settings
let NERDTreeShowHidden = 1
" auto close NT when file is opened
" let NERDTreeQuitOnOpen = 1
" open and close with tt
nmap tt :NERDTreeToggle<CR>
nmap tf :NERDTreeFind<CR>
let NERDTreeRespectWildIgnore=1
" disable ? for help
let NERDTreeMinimalUI = 1
" open NERDTree on starup
autocmd StdinReadPre * let s:std_in=1
" open nerdtree and put cursor in main window
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif
" open nerdtree
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif
" close vim with :q if only NERDTree is opened
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" ignore some basic folders
let NERDTreeIgnore=[".git/", ".idea", ".helm*", "__pycache__"]

" ALE settings
let g:ale_disable_lsp = 1
let g:ale_open_list = 0
let g:ale_lint_on_enter = 0
let g:ale_python_flake8_options = '--ignore=W191,E501,W504'
let g:ale_python_mypy_options = '--no-warn-no-return --disallow-untyped-defs'
let g:ale_linters = {
\   'python': ['flake8'],
\   'javascript': ['eslint'],
\   'go': ['gopls'],
\  'markdown': ['markdownlint', 'writegood', 'alex', 'proselint'],
\  'json': ['jsonlint'],
\ }
let g:ale_completion_enabled = 0
let g:ale_lint_delay = 1500
" highlight clear ALEErrorSign
let g:ale_sign_error = '!'
" highlight clear ALEWarningSign
let g:ale_sign_warning = '?'
nmap <leader>l :ALEToggle<CR>
highlight SpellCap ctermbg=52 cterm=none

" IndentLine: settings
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#75715e'
let g:indentLine_fileTypeExclude = ['markdown']

" Mark: settings
let g:mwDefaultHighlightingPalette = 'extended'
" let g:mwDefaultHighlightingPalette = 'maximum'
" clear screen for search and mark
noremap <C-c> :nohlsearch<CR>:MarkClear<CR>


" ##############################################################################
" LSC SETTINGS
" ##############################################################################
" language server executable MUST be in $PATH
" Javascript: npm install -g javascript-typescript-langserver
" HTML: npm install -g vscode-html-languageserver-bin

" LSC: settings
let g:lsc_trace_level = 'verbose'  " 'off', 'messages', or 'verbose'
let g:lsc_hover_popup = 0
let g:lsc_reference_highlights = v:false  " conflict with Mark plugin
" let g:lsc_enable_autocomplete = v:false  " disable autosomplete
" use path lsc server config in separate local variable
let g:pylsp_config = {
\   'command': 'pylsp',
\   'log_level': 1,
\   'suppress_stderr': v:true,
\   'workspace_config': {
    \'pyls': {
        \'configurationSources': ['flake8'],
        \'plugins': {
            \'flake8': {'enabled': v:true},
            \'pyflakes': {'enabled': v:true},
            \'pycodestyle': {'enabled': v:true},
            \},
        \},
    \},
\}
let g:gopls_config = {
    \'command': 'gopls',
    \'log_level': -1,
    \'suppress_stderr': v:true,
\}
let g:lsc_enable_autocomplete = 1
let g:lsc_server_commands = {
    \'python': g:pylsp_config,
    \'javascript': {
        \'command': 'javascript-typescript-stdio',
        \'log_level': -1,
        \'suppress_stderr': v:true,
    \},
    \'html': {
        \'command': 'html-languageserver --stdio',
        \'log_level': -1,
        \'suppress_stderr': v:true,
    \},
    \'go': g:gopls_config,
\}
let g:lsc_auto_map = {
    \'GoToDefinition': 'gd',
    \'GoToDefinitionSplit': 'gD',
    \'FindReferences': 'gu',
    \'NextReference': '<C-n>',
    \'PreviousReference': '<C-p>',
    \'FindImplementations': 'gI',
    \'FindCodeActions': 'ga',
    \'Rename': 'gr',
    \'ShowHover': 'K',
    \'DocumentSymbol': 'go',
    \'WorkspaceSymbol': 'gS',
    \'SignatureHelp': 'gm',
    \'Completion': 'completefunc',
\}
" let g:lsc_enable_autocomplete = 0
" set completeopt=menu,menuone,noinsert,noselect
" some linters hightlight Warning instead of Error
highlight Warning ctermbg=52 cterm=none

" FZF: settings
" search only inside project files (respect .gitignore)
nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>g :Rg<CR>
" replace simple buffers to fzf buffers
nnoremap <leader>b :Buffers<CR>

" VimTmuxNavigator: settings
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_wrap = 1

" VimAutoFormat: settings
command Fmt :Autoformat
" jq must be in $PATH
" brew install jq
let g:formatdef_jq = '"jq ."'
let g:formatters_json = ['jq']
let g:autoformat_verbosemode=1

" VimEmmet: settings
let g:user_emmet_leader_key='<C-e>'

" Undotree: settings
let g:undotree_WindowLayout = 3
let g:undotree_HelpLine = 1
nnoremap <leader>u :UndotreeShow<cr>:UndotreeFocus<CR>

" VimMarkdown: settings
let g:vim_markdown_folding_disabled = 1

" MarkdownPreview: settings
let g:mkdp_browser = 'firefox'
let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_start = 0

" VimSneak: settings
let g:sneak#label = 1
map <Leader>s <Plug>Sneak_s
highlight Sneak ctermfg=16 ctermbg=red

" Lightline: settings
function! IsWide()
    return winwidth(winnr()) > 100
endfunction
function! IsTerminal()
    return lightline#mode() == 'TERMINAL'
endfunction
" LSC only shown in non terminal
function! LightlineLSCServerStatus()
    if !IsTerminal()
        return LSCServerStatus()
    else
        return ''
endfunction
let g:lightline = {
\    'colorscheme': 'monokai',
\    'active': {
\        'left': [
\            [ 'mode', 'paste' ],
\            [ 'filename', 'readonly', 'modified' ],
\        ],
\        'right': [
\            [ 'percent', 'line' ],
\            [ 'lscstatus', 'filetype' ],
\            [ 'fileencoding', 'charvaluehex' ],
\        ],
\    },
\    'inactive': {
\        'right': [
\            [ 'percent', 'line' ],
\            [ 'filetype' ],
\        ],
\    },
\    'component': {
\        'modified': '%{IsTerminal()?"":&modified?"[+]":""}',
\        'charvaluehex': '0x%B',
\        'filetype': '%{&ft!=#""?&ft:""}',
\        'fileencoding': '%{(IsTerminal()||!IsWide())?"":&fenc!=#""?&fenc:&enc}',
\        'filename': '%{IsTerminal()?"":expand("%t")}',
\    },
\    'component_visible_condition': {
\        'modified': '(!IsTerminal() && &modified)',
\        'fileencoding': '(!IsTerminal() && IsWide())',
\    },
\    'component_function': {
\        'lscstatus': 'LightlineLSCServerStatus',
\    },
\ }
set noshowmode

" colorscheme
colorscheme monokai

" Argwap: settings
nnoremap <silent> <leader>d :ArgWrap<CR>
nnoremap <silent> <leader>j :ArgWrap<CR>
let g:argwrap_tail_comma = 1
autocmd FileType vim let b:argwrap_line_prefix = '\'

" EasyAlign: settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Timelapse: settings
map <leader>tl :call TimeLapse() <cr>

" Signify: settings
set updatetime=100
nmap tj <plug>(signify-next-hunk)
nmap tk <plug>(signify-prev-hunk)
nmap tu :SignifyHunkUndo<CR>
highlight SignifySignAdd    ctermbg=236 ctermfg=2
highlight SignifySignChange ctermbg=236 ctermfg=3
highlight SignifySignDelete ctermbg=236  ctermfg=52
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'
let g:signify_sign_show_count = 0

" Codefmt: settings
function! s:FormatPython() abort
    FormatCode isort
    FormatCode ruff
endfunction
augroup autoformat_settings
    autocmd FileType go AutoFormatBuffer gofmt
    autocmd FileType json AutoFormatBuffer js-beautify
    autocmd FileType html,css,sass,scss,less AutoFormatBuffer js-beautify
    autocmd FileType python AutoFormatBuffer isort
    autocmd FileType python command! Fmt :call s:FormatPython()
augroup END

" AutoPairs: settings
let b:AutoPairs = {'{': '}', '"""': '"""'}
autocmd FileType html let b:AutoPairs = {'<!--': '-->'}

" Dadbod: settings
function! GetEnv(var) abort
    return exists('*DotenvGet') ? DotenvGet(a:var) : eval('$'.a:var)
endfunction
let g:dbs = {
\ 'pg': printf(
    \'postgres://%s:%s@%s:%s/%s',
    \GetEnv('DB_USERNAME'),
    \GetEnv('DB_PASSWORD'),
    \GetEnv('DB_HOST'),
    \GetEnv('DB_PORT'),
    \GetEnv('DB_NAME'),
\),
\}
