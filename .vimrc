" encoding
set encoding=utf-8
scriptencoding utf-8

" generic vimrc
set nocompatible
syntax on
set encoding=utf-8
set colorcolumn=80

" allow to auto indent and auto tab
filetype on
filetype indent on
filetype plugin on

" hide buffer when it's abandoned
set hidden

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" tabs and spaces
set autoindent
set tabstop=4
set shiftwidth=0
set smarttab
set expandtab
set nojoinspaces
set list
set listchars=tab:\¦\ ,trail:·
" do not highlight in read-only buffers
autocmd BufWinEnter * if &buftype == 'nowrite' | setlocal nolist | endif

set pastetoggle=<leader>p

autocmd Filetype html,vue,htmldjango setlocal ts=2 sw=2 sts=2 expandtab matchpairs+=<:>
autocmd FileType sh iabbrev #! #!/bin/sh
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd FileType python setlocal ts=4 sw=4 sts=4 nolist expandtab
autocmd FileType markdown setlocal conceallevel=0

" Go: additional language settings
autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=0 nolist noexpandtab
autocmd FileType go iabbrev pack package name<CR><CR>import (<CR>"fmt"<CR>)<ESC>ggw
autocmd FileType go iabbrev iferr if err != nil {<CR>}<ESC>ko
autocmd FileType go iabbrev imp import (<CR>"fmt"<CR>)<ESC>kw

" Python: additional language settings
" Additional python highlight for monokai
autocmd FileType python syn match pythonSelf "\(\W\|^\)\@<=\(self\|cls\)\([\.,:)]\)\@="
autocmd FileType python syn match pythonOperator "\(:\?[<>=\-%+\*!|&^]\)"
autocmd FileType python syn match pythonNumber "\(\[\d_]*\)\b"
" autocomplete
autocmd FileType python iabbrev pdb breakpoint();<CR>pass
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
    if &buftype == 'terminal' || &buftype == 'nowrite'
        setlocal signcolumn=no nonumber norelativenumber
    elseif winwidth(winnr()) > &colorcolumn + 10
        setlocal signcolumn=auto
    else
        setlocal signcolumn=number
    endif
endfunction
autocmd WinResized * call UpdateSignColumn()

" resize all windows when window restized
" autocmd VimResized * :wincmd =

" show cursor line
set cursorline

" highlight errors with red bg
highlight SpellBad ctermbg=52 cterm=none

set ttyfast
set showcmd                                    " display incomplete command
" set completeopt=menu,menuone,noinsert,noselect " completion
set completeopt=menuone,noselect
set gdefault                                   " g is not required by default in :s/old/new/ command
set scrolloff=3
set undodir=~/.vim/undo
set mouse=                                     " Allow to select raw text from vim
set laststatus=2                               " always display the status line
set visualbell                                 " no sound bell
set splitright                                 " :vs split to right
set splitbelow                                 " :sp split to bottom
set backspace=indent,eol,start                 " Backspace deletes like most programs in insert mode
set textwidth=0                                " prevent from auto-newline
set nofoldenable                               " disable code folding
set formatoptions-=o                           " dont continue comments when pushing /O

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

" delete do not replace current buffer
nnoremap x "_x
vnoremap p "_dP

" scroll and center
nnoremap <C-e> <C-e>zz
nnoremap <C-y> <C-y>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
" nnoremap j jzz
" nnoremap k kzz

" do not require shift for :
nnoremap ; :
nnoremap : ;

" easy movement between panes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Terminal settings
nnoremap <leader>t :vert term<CR>
" nvim and vim configs are different
if !has('nvim')
    " VIM 9 terminal
    " easy movement for terminal
    tnoremap <C-j> <C-w>j
    tnoremap <C-k> <C-w>k
    tnoremap <C-l> <C-w>l
    tnoremap <C-h> <C-w>h
    " C-u will just scroll terminal buffer up
    tnoremap <C-u> <C-w><S-n><C-u>
    autocmd TerminalOpen * startinsert
    nnoremap <Return> i
else
    " NVIM terminal
    " nvim has differen terminal binding
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    autocmd TermOpen * startinsert

    " autocmd TerminalWinOpen * startinsert
    " tnoremap <C-u> <C-\><C-n><C-u>
    " nnoremap <Return> i
    autocmd UIEnter * echo "uienter"
    autocmd UILeave * echo "uileave"
    autocmd BufWinEnter * startinsert
endif

" clear highlight
" (overriden in Mark plugin settings)
map <leader>c :nohlsearch<CR>

" spell check
set spelllang=en_gb,ru
autocmd FileType txt setlocal spell
autocmd FileType rst setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
" autocmd FileType python setlocal spell

" additional error highlight
call matchadd('Error', '\s+$')

" Show syntax highlighting groups for word under cursor
nnoremap <leader>w :echo synIDattr(synID(line("."), col("."), 1), 'name')<CR>

" Show buffer and expect to enter buffer number
nmap <leader>b :buffers<cr>:buffer<space>

" netrw cofig
let g:netrw_banner = 0  " disable banner
let g:netrw_liststyle = 3  " tree view
" let g:netrw_browse_split = 4  " open in new split
" let g:netrw_altv = 1  " open in vertical split

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

" Fugitive: all actions with :Git
Plug 'tpope/vim-fugitive'

" Commentary: comment code with ease
Plug 'tpope/vim-commentary'

" Abolish: swap case with cr* and use smart :S instead of :s
Plug 'tpope/vim-abolish'

" SurrondWith: effective way to 'surround' str(code)
Plug 'tpope/vim-surround'

" VimRepeat: repeat surround and other stuff with .
Plug 'tpope/vim-repeat'

" IndentLine: add vertical line on on indent
Plug 'Yggdroot/indentLine'

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

" Markdown: syntax, tabs and render
" Plug 'godlygeek/tabular'
" Plug 'preservim/vim-markdown'
" If you don't have nodejs and yarn
" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
" see: https://github.com/iamcco/markdown-preview.nvim/issues/50
" run :MarkdownPreview to run web browser in sync with vim
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" VimSneak: Easy and smart movements with s key
Plug 'justinmk/vim-sneak'

" Copilot: AI completion tool
Plug 'github/copilot.vim'

" Lightline: fast configurable statusline
Plug 'itchyny/lightline.vim'

" ColorTemplate: convert colorscheme to template
" Plug 'lifepillar/vim-colortemplate'

" Argwrap: Split/Unsplit text in brackets
Plug 'FooSoft/vim-argwrap'

" EasyAlign: align text with ease
Plug 'junegunn/vim-easy-align'

" Timelapse: git history fun
" Plug 'vim-scripts/git-time-lapse'

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

" Dadbod: database client
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
" Plug 'kristijanhusak/vim-dadbod-completion' "Optional

" VimTest: run tests from vim
" not yet decided how to run tests
" Plug 'vim-test/vim-test'
" Plug 'tpope/vim-dispatch'
Plug 'christoomey/vim-tmux-runner'

" Arpeggio: jk to esc
Plug 'kana/vim-arpeggio'

" Unimaired: quickly navigate quickfix and more
" ]q [q for quickfix
Plug 'tpope/vim-unimpaired'

" Ropevim: autoimport and refactor
Plug 'python-rope/ropevim'

" HardMode: use motions more effectively
Plug 'dusans/vim-hardmode'

" VimHusk: readline mappings for command line
Plug 'vim-utils/vim-husk'

" PythonSense: python text objects: m for func/method, c for class
Plug 'jeetsukumaran/vim-pythonsense'

call plug#end()
call glaive#Install()

" Fugitive: settings
nnoremap ts :Git<CR>
nnoremap tb :Git blame<CR>
nnoremap td :Git diff<CR>
autocmd FileType fugitive nnoremap <buffer> tp :Git push<CR>
autocmd FileType fugitive nnoremap <buffer> tP :Git push -f<CR>
command! GitGraph vertical Git graph
autocmd FileType fugitive nnoremap <buffer> gg :GitGraph<CR>
" nnoremap tp :Git push<CR>
" nnoremap tP :Git push -f<CR>

" NERDTree: settings
let NERDTreeShowHidden = 1
" auto close NT when file is opened
" let NERDTreeQuitOnOpen = 1
" open and close with tt
nnoremap tt :NERDTreeToggle<CR>
nnoremap tf :NERDTreeFind<CR>
let NERDTreeRespectWildIgnore=1
" disable ? for help
let NERDTreeMinimalUI = 1
" open NERDTree on starup
autocmd StdinReadPre * let s:std_in=1
" open nerdtree and put cursor in main window
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif
" open nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif
" close vim with :q if only NERDTree is opened
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" TODO: now working with with fzf
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" ignore some basic folders
let NERDTreeIgnore=[".git/", ".idea", ".helm*", "__pycache__", ".ropeproject"]
" autocmd FileType nerdtree nnoremap <buffer> l 
let NERDTreeMapActivateNode = 'l'
let NERDTreeMapOpenRecursively = 'L'
let NERDTreeMapCloseDir = 'h'
let NERDTreeMapCloseChildren = 'H'

" ALE: settings
let g:ale_disable_lsp = 1
let g:ale_open_list = 0
let g:ale_lint_on_enter = 0
let g:ale_python_flake8_options = '--ignore=W191,E501,W504'
let g:ale_python_mypy_options = '--no-warn-no-return --disallow-untyped-defs'
let g:ale_linters = {
    \'python': ['flake8'],
    \'javascript': ['eslint'],
    \'go': ['gopls'],
    \'markdown': ['markdownlint', 'writegood', 'alex', 'proselint'],
    \'json': ['jsonlint'],
\}
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

" LSC: autocomplete
" debug :set comnifunc? :set completefunc?
let g:lsc_autocomplete_length = 50
autocmd FileType python set omnifunc=lsc#complete#complete

" LSC: servers
let g:pylsp_config = {
    \'command': 'pylsp',
    \'log_level': 1,
    \'suppress_stderr': v:true,
    \'workspace_config': {'pylsp': {'plugins': {}}},
\}
let g:pylsp_config.workspace_config.pylsp.plugins.flake8 = {'enabled': v:true}
" let g:pylsp_config.workspace_config.pylsp.plugins = {
"     \'rope_autoimport': {
"         \'enabled': v:true,
"         \'completions': {'enabled': v:true},
"     \},
" \}
let g:pyright_config = {
    \'command': 'pyright-langserver --stdio',
    \'log_level': -1,
    \'suppress_stderr': v:true,
\}
let g:gopls_config = {
    \'command': 'gopls',
    \'log_level': -1,
    \'suppress_stderr': v:true,
\}
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

" LSC: keymaps
let g:lsc_auto_map = {
    \'GoToDefinition': 'gd',
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
nnoremap gD :vertical LSClientGoToDefinitionSplit<CR>
autocmd FileType go nnoremap gi :LSClientFindCodeActions "Organize Imports"<CR>

" LSC: other
let g:lsc_reference_highlights = v:false  " conflict with Mark plugin
highlight Warning ctermbg=52 cterm=none  " fix highlight for LSC warnings


" FZF: settings
" move to prev buffer if NERDTree is opened
" TODO
function! FZFOpen(fzf_command)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

" nnoremap <silent> <C-b> :call FZFOpen(':Buffers')<CR>
" nnoremap <silent> <C-g>g :call FZFOpen(':Ag')<CR>
" nnoremap <silent> <C-g>c :call FZFOpen(':Commands')<CR>
" nnoremap <silent> <C-g>l :call FZFOpen(':BLines')<CR>
" nnoremap <silent> <C-p> :call FZFOpen(':Files')<CR>
" search only inside project file names (respect .gitignore)
nnoremap <Leader>f :GFiles<CR>
" search inside file content
nnoremap <Leader>g :Rg<CR>
" replace simple buffers to fzf buffers
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>; :Commands<CR>
nnoremap <leader>k :Maps<CR>


" VimTmuxNavigator: settings
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_wrap = 1

" VimMarkdown: settings
let g:vim_markdown_folding_disabled = 1

" MarkdownPreview: settings
let g:mkdp_browser = 'firefox'
let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_start = 0

" VimSneak: settings
let g:sneak#label = 1
" s key is mapped in NERDTree and Fugitive
augroup SneakNonNerdTreeOrFugitive
    autocmd!
    autocmd BufEnter * if index(['nerdtree', 'fugitive'], &buftype) != -1 | nnoremap <buffer> s <Plug>Sneak_s | endif
augroup END

" nnoremap s <Plug>Sneak_s
highlight! link Sneak Search
highlight! link SneakCurrent CurSearch

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
    endif
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
" Start interactive EasyAlign in visual mode (e.g. vipea)
xmap gea <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. eaip)
nmap gea <Plug>(EasyAlign)

" Timelapse: settings
" map <leader>tl :call TimeLapse() <cr>

" Signify: settings
set updatetime=100
nnoremap tu :SignifyHunkUndo<CR>
nnoremap tD :SignifyHunkDiff<CR>
nnoremap tj <plug>(signify-next-hunk)
nnoremap tk <plug>(signify-prev-hunk)
nnoremap ]c <plug>(signify-next-hunk)
nnoremap [c <plug>(signify-prev-hunk)
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
highlight SignifySignAdd    ctermbg=236 ctermfg=2
highlight SignifySignChange ctermbg=236 ctermfg=3
highlight SignifySignDelete ctermbg=236  ctermfg=1
" ascii \u258D is used. Also try \u258A-F
" let g:column_sign = '▍'  " \u258D
" let g:column_sign = '▎'  " \u258E
let g:column_sign = '▏'  " \u258F
let g:signify_sign_add = g:column_sign
let g:signify_sign_delete = g:column_sign
let g:signify_sign_change = g:column_sign
let g:signify_sign_show_count = 0

" Codefmt: settings
augroup autoformat_settings
    autocmd FileType go AutoFormatBuffer gofmt
    autocmd FileType json AutoFormatBuffer prettier
    autocmd FileType html AutoFormatBuffer prettier
    " autocmd FileType html,css,sass,scss,less AutoFormatBuffer prettier
    autocmd FileType js,ts AutoFormatBuffer prettier
augroup END

function! g:FormatBuffer() abort
    let l:formatters = {
    \ 'python':    ['ruff', 'isort'],
    \ }
    let l:ft = &filetype
    if !has_key(l:formatters, l:ft)
        return
    endif
    for fmt in l:formatters[l:ft]
        execute 'FormatCode ' . fmt
    endfor
endfunction
command! -nargs=0 Fmt call g:FormatBuffer()

autocmd BufWritePost *.py call g:FormatBuffer()


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

" VimTest: settings TODO
" working:
nmap <leader>rf :TestFile<CR>
nmap <leader>rt :TestNearest<CR>
" working
let test#strategy = 'vtr'  " run test in tmux and keep pane- working great, but need manual activation
" let test#strategy = 'vimterminal'
" let test#strategy = 'spawn'  " bg vim and run tests
" let test#strategy = 'dispatch'  " bg with dispatch
" to check:
" not working:
" let test#strategy = 'tslime'

" Copilot: settings
let g:copilot_workspace_folders = ["~/code/lionsoul-backend", "~/code/moscowliuda-webinar-utils"]
imap <silent><script><expr> <C-e> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" VimArpeggio: settings
" Arpeggio inoremap jk  <Esc>
call arpeggio#map('i', '', 0, 'jk', '<Esc>')

" Ropevim: settings
let g:ropevim_enable_shortcuts = 0
let g:ropevim_autoimport_modules = [
    \"asyncio",
    \"collections",
    \"contextlib",
    \"dataclasses",
    \"datetime",
    \"fastapi",
    \"functools",
    \"itertools",
    \"json",
    \"logging",
    \"time",
    \"os",
    \"pytest",
    \"re",
    \"requests",
    \"shutil",
    \"sys",
    \"typing",
\]
nnoremap <leader>i :RopeAutoImport<CR><ESC>:w<CR>
nnoremap <leader>I :RopeGenerateAutoimportCache<CR>
