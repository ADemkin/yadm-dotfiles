" ~/.vimrc - minimal standalone Vim config

set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

filetype plugin indent on
syntax on

" gc comment operator; shipped with Vim 9.1+ only, silently skipped on older VDS boxes
if has('patch-9.1.0375')
  packadd! comment
endif

" Files, undo, buffers
set hidden                        " keep abandoned buffers loaded
if has('clipboard')
  " macOS Vim uses the * register; unnamedplus is Neovim/X11 only
  set clipboard=unnamed
endif
set noswapfile
set nobackup
set nowritebackup
set autoread                      " reload file when changed outside vim
set undofile                      " persistent undo
set undodir=~/.vim/undo//
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set breakindent
set nojoinspaces

" UI
set background=dark
if has('termguicolors')
  set termguicolors
endif
set number
set relativenumber
set numberwidth=1
set signcolumn=auto
set cursorline
set colorcolumn=80
set scrolloff=99
set laststatus=2
set showmode
set showcmd
set pumheight=10
set linebreak
set textwidth=0                   " never auto-wrap
set nofoldenable
set visualbell
set t_vb=
set splitright
set splitbelow
set backspace=indent,eol,start
set mouse=                        " let the terminal handle selection
set updatetime=100
set timeoutlen=1000
set ttimeout
set ttimeoutlen=100               " no <Esc> lag in the terminal
set title
set history=1000
set sidescrolloff=5
set nrformats-=octal              " 007 <C-a> is 8, not 010
set sessionoptions-=options
set viewoptions-=options
set switchbuf=useopen,usetab
set diffopt+=algorithm:histogram,indent-heuristic
set list
set listchars=tab:\¦\ ,trail:·
set fillchars+=vert:\│

set statusline=\ %f\ %m%r%h%w%=\ %y\ %{&fileencoding?&fileencoding:&encoding}\ \|\ %l:%c\ \|\ %p%%\ \|

" Search
set ignorecase
set smartcase
set infercase
set hlsearch
set incsearch
set gdefault

" Completion & wildmenu
set completeopt=menuone,noselect
set shortmess+=c
set wildmenu
set wildmode=list:longest,full
set iskeyword+=-

" :find as a poor man's fuzzy finder
set path+=**
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/target/*,*/__pycache__/*,*.o,*.pyc

" netrw (built-in file explorer)
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Keymaps
nnoremap <Space> <Nop>
let mapleader = ' '
let maplocalleader = ' '

" Command mode without shift
nnoremap ; :
nnoremap : ;

" Keep the cursor centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

" Move visual selection up/down
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" Don't clobber the unnamed register
nnoremap x "_x
vnoremap p "_dP

" Clear search highlight
nnoremap <silent> <C-c> :nohlsearch<CR>

" Quickfix / location list navigation (vim-unimpaired subset)
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> <leader>q :copen<CR>

" Buffers
nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Terminal
nnoremap <C-y> :vert term<CR>
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

" Autocommands
augroup vimrc
  autocmd!

  " Return to the last cursor position when reopening a file
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# 'commit'
        \ |   execute "normal! g`\""
        \ | endif

  " Never continue comments on o/O or <CR>
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  autocmd TerminalWinOpen * setlocal nolist nonumber norelativenumber

  " Help windows open on the right
  autocmd BufWinEnter *.txt if &buftype ==# 'help' | wincmd L | vertical resize 84 | endif

  " Equalize splits when the terminal is resized
  autocmd VimResized * wincmd =
augroup END

let g:colors_name = 'monokai'

hi Normal       guifg=#E8E8E3 guibg=#272822 ctermfg=252 ctermbg=234
hi ColorColumn  guibg=#2D2E27 ctermbg=235
hi CursorLine   guibg=#2D2E27 ctermbg=235 term=NONE cterm=NONE gui=NONE
hi CursorColumn guibg=#383a3e ctermbg=236
hi LineNr       guifg=#8F908A guibg=#2D2E27 ctermfg=243 ctermbg=235 term=NONE cterm=NONE gui=NONE
hi CursorLineNr guifg=#FD9720 guibg=#2D2E27 ctermfg=208 ctermbg=235 term=NONE cterm=NONE gui=NONE
hi SignColumn   guibg=#2D2E27 ctermbg=235
hi NonText      guifg=#575b61 ctermfg=237
hi SpecialKey   guifg=#575b61 ctermfg=237
hi Visual       guibg=#575b61 ctermbg=237
hi Search       guifg=#272822 guibg=#E6DB74 ctermfg=234 ctermbg=186
hi IncSearch    guifg=#272822 guibg=#FD9720 ctermfg=234 ctermbg=208
hi MatchParen   guifg=#272822 guibg=#ae81ff ctermfg=234 ctermbg=141
hi VertSplit    guifg=#64645e guibg=#272822 ctermfg=239 ctermbg=234
hi StatusLine   guifg=#E8E8E3 guibg=#211F1C ctermfg=252 ctermbg=233 term=NONE cterm=NONE gui=NONE
hi StatusLineNC guifg=#75715E guibg=#211F1C ctermfg=59 ctermbg=233 term=NONE cterm=NONE gui=NONE
hi TabLine      guifg=#E8E8E3 guibg=#211F1C ctermfg=252 ctermbg=233 cterm=NONE gui=NONE
hi TabLineFill  guibg=#211F1C ctermbg=233
hi TabLineSel   guifg=#E8E8E3 guibg=#2D2E27 ctermfg=252 ctermbg=235 cterm=NONE gui=NONE
hi Folded       guifg=#75715E guibg=#211F1C ctermfg=59 ctermbg=233
hi FoldColumn   guibg=#211F1C ctermbg=233
hi Question     guifg=#E6DB74 ctermfg=186
hi ModeMsg      guifg=#E6DB74 ctermfg=186
hi MoreMsg      guifg=#E6DB74 ctermfg=186
hi ErrorMsg     guifg=#272822 guibg=#e73c50 ctermfg=234 ctermbg=196
hi WarningMsg   guifg=#e73c50 ctermfg=196
hi Title        guifg=#E6DB74 ctermfg=186
hi Directory    guifg=#66d9ef ctermfg=81

" popup menu
hi Pmenu      guifg=#E8E8E3 guibg=#2D2E27 ctermfg=252 ctermbg=235
hi PmenuSel   guifg=#E8E8E3 guibg=#383a3e ctermfg=252 ctermbg=236
hi PmenuSbar  guibg=#2D2E27 ctermbg=235
hi PmenuThumb guifg=#2D2E27 guibg=#8F908A ctermfg=235 ctermbg=243

" diff
hi DiffAdd    guifg=#d7ffaf guibg=#5f875f ctermfg=193 ctermbg=65
hi DiffDelete guifg=#272822 guibg=#f75f5f ctermfg=234 ctermbg=167
hi DiffChange guifg=#d7d7ff guibg=#5f5f87 ctermfg=189 ctermbg=60
hi DiffText   guifg=#272822 guibg=#66d9ef ctermfg=234 ctermbg=81
hi diffAdded   guifg=#A6E22D ctermfg=148
hi diffRemoved guifg=#e73c50 ctermfg=196

" generic syntax
hi Comment    guifg=#75715E ctermfg=59 gui=italic cterm=NONE
hi Constant   guifg=#ae81ff ctermfg=141
hi Number     guifg=#ae81ff ctermfg=141
hi Float      guifg=#ae81ff ctermfg=141
hi Boolean    guifg=#ae81ff ctermfg=141
hi Character  guifg=#E6DB74 ctermfg=186
hi String     guifg=#E6DB74 ctermfg=186
hi Identifier guifg=#E8E8E3 ctermfg=252 cterm=NONE gui=NONE
hi Function   guifg=#A6E22D ctermfg=148
hi Statement  guifg=#66d9ef ctermfg=81 cterm=NONE gui=NONE
hi Conditional guifg=#F92772 ctermfg=197
hi Repeat     guifg=#F92772 ctermfg=197
hi Label      guifg=#ae81ff ctermfg=141
hi Operator   guifg=#66d9ef ctermfg=81
hi Keyword    guifg=#66d9ef ctermfg=81
hi Exception  guifg=#F92772 ctermfg=197
hi PreProc    guifg=#A6E22D ctermfg=148
hi Include    guifg=#F92772 ctermfg=197
hi Define     guifg=#F92772 ctermfg=197
hi Macro      guifg=#A6E22D ctermfg=148
hi PreCondit  guifg=#A6E22D ctermfg=148
hi Type       guifg=#66d9ef ctermfg=81 cterm=NONE gui=NONE
hi StorageClass guifg=#66d9ef ctermfg=81
hi Structure  guifg=#A6E22D ctermfg=148
hi Typedef    guifg=#A6E22D ctermfg=148
hi Special    guifg=#ae81ff ctermfg=141
hi SpecialChar guifg=#F92772 ctermfg=197
hi Delimiter  guifg=#F92772 ctermfg=197
hi SpecialComment guifg=#66d9ef ctermfg=81
hi Tag        guifg=#F92772 ctermfg=197
hi Underlined guifg=#A6E22D ctermfg=148 cterm=underline gui=underline
hi Ignore     guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
hi Todo       guifg=#FD9720 guibg=NONE ctermfg=208 cterm=bold gui=bold,italic
hi Error      guifg=#e73c50 guibg=#5f0000 ctermfg=196 ctermbg=52
hi SpellBad   guifg=NONE guibg=#5f0000 ctermbg=52 cterm=NONE gui=undercurl guisp=#e73c50
hi SpellCap   guibg=NONE ctermbg=NONE cterm=NONE gui=undercurl guisp=#66d9ef
hi SpellRare  guibg=NONE ctermbg=NONE cterm=NONE gui=undercurl guisp=#ae81ff
hi SpellLocal guibg=NONE ctermbg=NONE cterm=NONE gui=undercurl guisp=#A6E22D

" trailing whitespace
hi TrailingWhitespace guibg=#e73c50 ctermbg=196
match TrailingWhitespace /\s\+$/

let g:terminal_ansi_colors = [
      \ '#272822', '#F92772', '#A6E22D', '#E6DB74',
      \ '#66d9ef', '#ae81ff', '#a1efe4', '#E8E8E3',
      \ '#272822', '#F92772', '#A6E22D', '#E6DB74',
      \ '#66d9ef', '#ae81ff', '#a1efe4', '#E8E8E3',
      \ ]
