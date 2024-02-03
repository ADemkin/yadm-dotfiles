" generic vimrc
set nocompatible
syntax on
set encoding=utf-8
set ruler
set colorcolumn=80

" allow to auto indent and auto tab
filetype on
filetype indent on
filetype plugin on
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set nojoinspaces

set ttyfast
set isfname-=:
set noswapfile  " do not create *.sw[op] files

" relative number for all but current line
set signcolumn=number  " replace numbers with lint info, require vim >= 8.1.1564 (was number)
" set signcolumn=yes
set number
set relativenumber
set numberwidth=1

" show cursor line
set cursorline

" highlight errors with red bg
highlight SpellBad ctermbg=52 cterm=none

set showcmd " display incomplete command
" act like IDE completion, :help completeopt
" set completeopt=longest,menuone
" recomended settings for LSC, :help completeopt
set completeopt=menu,menuone,noinsert,noselect
set listchars=tab:\|\ ,trail:·
set list
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
" set pastetoggle=<leader>i  " switch paste mode with space-i

" Set true colors or 256 colors
set t_Co=256
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" set termguicolors

" vertical split appearance
set fillchars+=vert:\│

" Setting dark mode
set background=dark

" Set scolorscheme
colorscheme monokai

" ignore case while searching
set ignorecase
set smartcase
set hlsearch
set incsearch
highlight MatchParen ctermbg=yellow


" (re)store session on exit
" autocmd BufWinLeave *.* mkview
" autocmd BufWinEnter *.* silent loadview

" Let menu act like shell
set wildmenu
set wildmode=list:longest,full
set wildignore=**/_build/*,**/tags,**/.git,**/.hypothesis
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
set wildignore+=**/*.egg-info,**/.*_cache
set wildignore+=**/__pychache__

" Add fzf to completions
set rtp+=/opt/homebrew/opt/fzf


" ######
" REMAPS
" ######

" Map Space as Leader
nnoremap <SPACE> <Nop>
map <Space> <Leader>

" easy paste with Control-V (safe for macOS)
" nnoremap <C-v> :set paste<CR>"+p:set nopaste<CR>

" paste without loosing current buffer
vnoremap ‹leader>p "\"_d

" move visual selection up and down with J/K
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" p not overwrite current buffer with visual selection
vnoremap <leader>p "_dP

" do not require shift for :
nmap ; :

" easy movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Terminal settings
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
tnoremap <C-u> <C-w>:set nonu nornu<CR><C-w><S-n><C-u>
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

" simple import sort
" nmap ss :set lazyredraw<CR>vip:sort u<CR>:'<,'>sort i<CR>:set nolazyredraw<CR>

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

" GitGutter: track git changes from line number
Plug 'airblade/vim-gitgutter'

" Commentary: comment code with ease
Plug 'tpope/vim-commentary'

" Abolish: swap case with cr* and use smart :S instead of :s
Plug 'tpope/vim-abolish'

" Isort: sort python imports
Plug 'fisadev/vim-isort', { 'for': 'python' }

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
Plug 'vim-scripts/VimCompletesMe'

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

" Signify: show diff with style
" Plug 'mhinz/vim-signify'

" Copilot: AI completion tool
Plug 'github/copilot.vim'

" CtrlSF: Async search in project in separate window
" Plug 'dyng/ctrlsf.vim'
" :CtrlSF to search in project
" M to toggle compact mode
" O/Enter to move cursor to current match

" GruvBox: depressive colorscheme
" Plug 'morhetz/gruvbox'

" Lightline: fast configurable statusline
Plug 'itchyny/lightline.vim'

" VimVue: Vue syntax
Plug 'posva/vim-vue'

call plug#end()

" After first vim load you need to run :PlugInstall manually

"##############################################################################
" STATUSLINE
"##############################################################################
" hi User1 ctermfg=blue ctermbg=black
" hi User2 ctermfg=green ctermbg=black
" hi User3 ctermfg=yellow ctermbg=black
" hi User4 ctermfg=red ctermbg=black
" hi User5 ctermfg=grey ctermbg=black
" set laststatus=2
" " use :help statusline to decrypt all those %
" set statusline=%n:%F%m%r%h%w%q\ %=
" set statusline+=%1*%Y[%{strlen(&fenc)?&fenc:&enc},%{&ff}]
" set statusline+=%2*[%l:%c%V/%L]
" set statusline+=%3*[0x%B]
" set statusline+=%4*[%{GetLspStatus()}]
" set statusline+=%*\ %P
" set titleold = ""
" function! GetLspStatus() abort
"     return LSCServerStatus()
"     " return lsp#get_server_status()
" endfunction

" Defstplit by Stargrave
" http://www.git.stargrave.org/?p=dotfiles.git;a=tree;f=vim/.vim/pack/stargrave/start/defsplit;hb=HEAD
nnoremap <Leader>s :Defsplit<CR>

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
let NERDTreeIgnore=[".git", ".idea", ".helm*", "__pycache__"]

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
let g:ale_fixers = {
\   'python': ['isort', 'autoimport', 'black'],
\}
let g:ale_completion_enabled = 0
let g:ale_lint_delay = 1500
" highlight clear ALEErrorSign
let g:ale_sign_error = '!'
" highlight clear ALEWarningSign
let g:ale_sign_warning = '?'
nmap <leader>l :ALEToggle<CR>
nmap <leader>a :ALEToggle<CR>
noremap g] :ALENext<cr>
noremap gn :ALENext<cr>
noremap g[ :ALEPrevious<cr>
noremap gp :ALEPrevious<cr>
highlight SpellCap ctermbg=52 cterm=none

" Isort settings
" isort must be installed in vim's python:
" $ pip install isort
" $ pip install pyls-isort
" :python3 import sys; print(sys.path)  # to get python path
" $PYTHON_PATH -m pip install isort
let g:vim_isort_python_version = 'python3'
" let g:vim_isort_map = '<C-s>'
" force single line import:
let g:vim_isort_config_overrides = {
    \'force_single_line': 2,
    \'from_first': 1,
    \'lexicographical': 1,
    \'atomic': 1,
    \'lines_after_imports': 2,
\}
" Avito style:
" http://stash.msk.avito.ru/projects/PYTHON/repos/pystyle/browse/lib/default.toml
" let g:vim_isort_config_overrides = {
"     \'profile': 'black',
"     \'line_length': 99,
"     \'atomic': 1,
"     \'default_section': 'THIRDPARTY',
"     \'known_first_party': ['src', 'lib', 'tests'],
"     \'include_trailing_comma': 1,
" \}
noremap si :Isort<CR>


" GitGutter: settings
nmap tu :GitGutterUndoHunk<CR>
nmap tj :GitGutterNextHunk<CR>
nmap tk :GitGutterPrevHunk<CR>
" highlight SignColumn ctermbg=8
" highlight SignColumn ctermbg=22
" highlight SignColumn ctermbg=58
highlight GitGutterAdd    ctermbg=235 ctermfg=2
highlight GitGutterChange ctermbg=235 ctermfg=3
highlight GitGutterDelete ctermbg=235 ctermfg=1
" may look different depending on font
" nice signs to copy-paste: ● ○ ◉ ◉ ◎ ⦿
let g:gitgutter_sign_added = '+'
" let g:gitgutter_sign_added = '●'
let g:gitgutter_sign_modified = '●'
" let g:gitgutter_sign_removed = '●'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '●'
let g:gitgutter_sign_removed_above_and_below = '●'
let g:gitgutter_sign_modified_removed = '●'

" Fugitive: Settings
nmap td :Git diff<CR>
nmap tb :Git blame<CR>

" IndentLine: settings
let g:indentLine_color_term = 239
let g:indentLine_fileTypeExclude = ['markdown']

" Mark: settings
let g:mwDefaultHighlightingPalette = 'extended'
" let g:mwDefaultHighlightingPalette = 'maximum'
" clear screen for search and mark
noremap <C-c> :nohlsearch<CR>:MarkClear<CR>

" #################### LANGUAGES CUSTOM SETTINGS ###############################
"
" ts = tabstop - number of spaces to count as tab
" sw = shiftwidth - number of spaces used as autoindent
" sts = softtabstop
" nolist = do not draw | as tab
" expandtab = replace tab with spaces
"
" HTML settings
autocmd Filetype htmldjango setlocal ts=4 sw=4 sts=4 expandtab matchpairs+=<:>
autocmd Filetype html setlocal ts=4 sw=4 sts=4 expandtab matchpairs+=<:>

" Shell settings
autocmd FileType sh iabbrev #! #!/bin/sh

" Javascript settings
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype vue setlocal ts=4 sw=4 sts=4 expandtab matchpairs+=<:>

" Python Settings
autocmd FileType python setlocal ts=4 sw=4 sts=4 nolist expandtab
" Additional python highlight for monokai
autocmd FileType python syn match pythonSelf "\(\W\|^\)\@<=\(self\|cls\)\([\.,:)]\)\@="
autocmd FileType python syn match pythonOperator "\(:\?[<>=\-%+\*!|&^]\)"
autocmd FileType python syn match pythonNumber "\(\[\d_]*\)\b"
" autocomplete
autocmd FileType python iabbrev pdb import pdb ; pdb.set_trace();<CR>pass
autocmd FileType python iabbrev spdb import sys, pdb; pdb.Pdb(stdout=sys.__stdout__).set_trace()
autocmd FileType python iabbrev ifname if __name__ == '__main__':<CR>
autocmd FileType python iabbrev init_ def __init__(self) -> None:<CR>pass
autocmd FileType python nnoremap <leader>i :!autoimport %<CR>

" Go settings
autocmd FileType go setlocal ts=4 sw=4 sts=4 nolist expandtab
" autocmd FileType go iabbrev iferr if err != nil {<cr>panic(err)
autocmd FileType go iabbrev iferr if err != nil {<cr>log.Fatal(err)
" autocmd FileType go syn match goStatement "\(:\?[<>=\-%+\*!|&^]\)"
autocmd FileType go syn match goStatement "\(:=\)"

" Markdown Settings
autocmd FileType markdown setlocal conceallevel=0


" ##############################################################################
" LSC SETTINGS
" ##############################################################################

" install LSP servers:
" language server executable MUST be in $PATH
" Python: python -m pip install 'python-lsp-server[all]'
" Javascript: npm install -g javascript-typescript-langserver
" Vue: npm install -g vls
" HTML: npm install -g vscode-html-languageserver-bin
" Go: go install golang.org/x/tools/gopls@latest
" https://cs.opensource.google/go/x/tools/+/refs/tags/gopls/v0.8.3:gopls/doc/vim.md

" LSC settings
let g:lsc_trace_level = 'verbose'  " 'off', 'messages', or 'verbose'
let g:lsc_hover_popup = 0
let g:lsc_reference_highlights = v:false  " conflict with Mark plugin
" let g:lsc_enable_autocomplete = v:false  " disable autosomplete
let g:lsc_enable_autocomplete = 1
let g:lsc_server_commands = {
    \'python': {
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
    \},
    \'javascript': {
    \    'command': 'javascript-typescript-stdio',
    \    'log_level': -1,
    \    'suppress_stderr': v:true,
    \},
    \'vue': {
    \    'command': 'vls --stdio',
    \    'log_level': -1,
    \    'suppress_stderr': v:true,
    \},
    \'html': {
        \'command': 'html-languageserver --stdio',
        \'log_level': -1,
        \'suppress_stderr': v:true,
    \},
    \'go': {
        \'command': 'gopls serve',
        \'log_level': -1,
        \'suppress_stderr': v:true,
    \},
\}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'GoToDefinitionSplit': 'gD',
    \ 'FindReferences': 'gu',
    \ 'NextReference': '<C-n>',
    \ 'PreviousReference': '<C-p>',
    \ 'FindImplementations': 'gI',
    \ 'FindCodeActions': 'ga',
    \ 'Rename': 'gr',
    \ 'ShowHover': 'K',
    \ 'DocumentSymbol': 'go',
    \ 'WorkspaceSymbol': 'gS',
    \ 'SignatureHelp': 'gm',
    \ 'Completion': 'completefunc',
\}
" let g:lsc_enable_autocomplete = 0
" set completeopt=menu,menuone,noinsert,noselect
" some linters hightlight Warning instead of Error
highlight Warning ctermbg=52 cterm=none

" FZF: settings
" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
" search only inside project files (respect .gitignore)
nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>g :Rg<CR>
" replace simple buffers to fzf buffers
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :Help<CR>
nnoremap <leader>hc :Commands<CR>
nnoremap <leader>hk :Maps<CR>

" VimTmuxNavigator: settings
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_wrap = 1

" VimAutoFormat: settings
command Fmt :Autoformat
" black must be in $PATH
" pip install black
let g:formatters_python = ['black']
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
" autocmd BufEnter *.md echomsg ":MarkdownPreview to open preview in firefox"
" start automatically when open .md file instead of manually with :MarkdownPreview
let g:mkdp_auto_start = 0

" VimSneak: settings
let g:sneak#label = 1
map <Leader>s <Plug>Sneak_s
highlight Sneak ctermfg=16 ctermbg=red

" GruvBox: settings
" set termguicolors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" let g:gruvbox_contrast_dark = 'hard'
" colorscheme gruvbox

" Lightline: settings
function! IsWide()
    return winwidth(0) > 78
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
" branch is only shown in wide
function! LightlineFugitiveHead()
    if IsWide()
        return FugitiveHead()
    else
        return ''
endfunction
" modified is only shown in non terminal
" enc is only shown in wide and non terminal
" hex is only shown in wide and non terminal
let g:lightline = {
\    'colorscheme': 'srcery_drk',
\    'active': {
\        'left': [
\            [ 'mode', 'paste' ],
\            [ 'filename', 'readonly', 'modified' ],
\            [ 'gitbranch' ],
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
\        'charvaluehex': '0x%B',
\        'filetype': '%{&ft!=#""?&ft:""}',
\    },
\    'component_visible_condition': {
\        'readony': '!&modifiable && &readonly',
\        'modified': '&modifiable && &modified',
\    },
\    'component_function': {
\        'gitbranch': 'LightlineFugitiveHead',
\        'lscstatus': 'LightlineLSCServerStatus',
\    },
\ }
